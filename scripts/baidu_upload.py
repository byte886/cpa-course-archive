#!/usr/bin/env python3
"""百度网盘文件上传脚本 - 分片上传大文件

用法:
  BAIDU_ENC_PASS=lover123 python3 baidu_upload.py <本地文件> <网盘路径> [token]

网盘路径必须以 /apps/CPA课程归档/ 开头。
直连百度服务器（不走代理），自动用 114 DNS 解析以兼容 Tailscale 环境。
"""

import hashlib
import json
import os
import subprocess
import sys
import tempfile

CHUNK_SIZE = 4 * 1024 * 1024  # 4MB
API_HOST = "pan.baidu.com"
UPLOAD_HOST = "d.pcs.baidu.com"
API_BASE = f"https://{API_HOST}/rest/2.0/xpan/file"
UPLOAD_BASE = f"https://{UPLOAD_HOST}/rest/2.0/pcs/superfile2"
FALLBACK_DNS = "114.114.114.114"


def resolve_dns(host):
    """用指定 DNS 服务器解析域名，返回 IP（兼容 Tailscale 劫持系统 DNS 的情况）"""
    try:
        result = subprocess.run(
            ["nslookup", host, FALLBACK_DNS],
            capture_output=True, text=True, timeout=5
        )
        # 解析 nslookup 输出，取最后一个 Address
        for line in result.stdout.splitlines():
            if line.startswith("Address:") and "#" not in line:
                # 有些行是 "Address: 114.114.114.114#53"（DNS服务器本身）
                ip = line.split("Address:")[1].strip()
                if "#" not in ip:
                    return ip
    except Exception as e:
        print(f"  DNS resolution warning: {e}", file=sys.stderr)
    return None


def get_resolve_args():
    """获取 curl --resolve 参数，绕过系统 DNS"""
    args = []
    for host in [API_HOST, UPLOAD_HOST]:
        ip = resolve_dns(host)
        if ip:
            args += ["--resolve", f"{host}:443:{ip}"]
    return args


def get_token():
    """从加密文件解密获取 access_token"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(script_dir)
    enc_file = os.path.join(project_dir, ".secrets", "baidu_credentials.enc")

    password = os.environ.get("BAIDU_ENC_PASS", "")
    if not password:
        import getpass
        password = getpass.getpass("Enter decryption password: ")

    result = subprocess.run(
        ["openssl", "enc", "-aes-256-cbc", "-d", "-pbkdf2",
         "-pass", f"pass:{password}", "-base64", "-in", enc_file],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"Decrypt failed: {result.stderr}", file=sys.stderr)
        sys.exit(1)
    return json.loads(result.stdout)["access_token"]


def curl_api(url, params=None, data=None, file_path=None, file_field="file", timeout=300):
    """通过 curl 直连调用 API（不走代理，用 --resolve 绕过 DNS）"""
    if params:
        url += "?" + "&".join(f"{k}={v}" for k, v in params.items())

    cmd = ["curl", "-s", "--connect-timeout", "10"] + get_resolve_args()

    if file_path:
        cmd += ["-F", f"{file_field}=@{file_path}"]
    if data:
        for k, v in data.items():
            cmd += ["--data-urlencode", f"{k}={v}"]
    elif not file_path:
        cmd += ["-X", "POST"]

    cmd.append(url)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    if result.returncode != 0:
        raise RuntimeError(f"curl failed: {result.stderr}")
    return json.loads(result.stdout)


def upload_file(local_path, remote_path, token):
    """分片上传文件到百度网盘"""
    file_size = os.path.getsize(local_path)
    print(f"Uploading: {local_path} ({file_size / 1024 / 1024:.1f} MB)")
    print(f"Remote: {remote_path}")

    # 1. 计算分片 MD5
    chunks = []
    block_list = []
    with open(local_path, "rb") as f:
        while True:
            chunk = f.read(CHUNK_SIZE)
            if not chunk:
                break
            chunks.append(chunk)
            block_list.append(hashlib.md5(chunk).hexdigest())
    print(f"Chunks: {len(chunks)}")

    # 2. precreate
    print("[1/3] Precreate...")
    result = curl_api(API_BASE, {
        "method": "precreate",
        "access_token": token,
    }, {
        "path": remote_path,
        "size": str(file_size),
        "isdir": "0",
        "autoinit": "1",
        "block_list": json.dumps(block_list),
    })
    if result.get("errno") != 0:
        print(f"Precreate failed: {result}", file=sys.stderr)
        sys.exit(1)
    uploadid = result["uploadid"]
    need_upload = result.get("block_list", list(range(len(chunks))))
    print(f"  Need upload: {len(need_upload)} chunks (MD5 sec-upload possible)")

    # 3. 上传分片
    tmp_dir = tempfile.mkdtemp(prefix="baidu_upload_")
    try:
        for i, seq in enumerate(need_upload):
            chunk_file = os.path.join(tmp_dir, f"chunk_{seq}")
            with open(chunk_file, "wb") as f:
                f.write(chunks[seq])

            pct = (i + 1) / len(need_upload) * 100
            print(f"[2/3] Chunk {seq} ({i+1}/{len(need_upload)}, {pct:.0f}%)...", end=" ", flush=True)
            result = curl_api(UPLOAD_BASE, {
                "method": "upload",
                "access_token": token,
                "type": "tmpfile",
                "path": remote_path,
                "uploadid": uploadid,
                "partseq": str(seq),
            }, file_path=chunk_file)
            os.remove(chunk_file)

            if "md5" in result:
                print("OK")
            else:
                print(f"FAILED: {result}")
                sys.exit(1)
    finally:
        os.rmdir(tmp_dir)

    # 4. create (合并)
    print("[3/3] Merging chunks...")
    result = curl_api(API_BASE, {
        "method": "create",
        "access_token": token,
    }, {
        "path": remote_path,
        "size": str(file_size),
        "isdir": "0",
        "block_list": json.dumps(block_list),
        "uploadid": uploadid,
    })
    if result.get("errno") != 0:
        print(f"Create failed: {result}", file=sys.stderr)
        sys.exit(1)
    print(f"  Done! fs_id: {result.get('fs_id')}, size: {result.get('size')}")
    return result


def mkdir_p(remote_dir, token):
    """递归创建网盘目录（沙箱内，跳过 /apps 系统目录）"""
    parts = remote_dir.strip("/").split("/")
    current = ""
    for part in parts:
        current += "/" + part
        if current == "/apps":
            continue
        result = curl_api(API_BASE, {
            "method": "mkdir",
            "access_token": token,
        }, {"path": current})
        if result.get("errno") == 0:
            print(f"  Created: {current}")
        elif result.get("errno") == 31061 or result.get("error_code") == 31061:
            pass  # already exists
        else:
            print(f"  mkdir {current} returned: {result}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    local_file = sys.argv[1]
    remote_file = sys.argv[2]
    token = sys.argv[3] if len(sys.argv) > 3 else get_token()

    if not os.path.isfile(local_file):
        print(f"File not found: {local_file}", file=sys.stderr)
        sys.exit(1)

    # 显示 DNS 解析结果
    for host in [API_HOST, UPLOAD_HOST]:
        ip = resolve_dns(host)
        print(f"DNS: {host} -> {ip or 'FAILED'}")

    # 确保远程目录存在
    remote_dir = os.path.dirname(remote_file)
    if remote_dir and remote_dir != "/":
        print(f"Ensuring directory: {remote_dir}")
        mkdir_p(remote_dir, token)

    upload_file(local_file, remote_file, token)
