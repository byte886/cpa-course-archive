#!/bin/bash
# 密钥管理工具 - 加密存储敏感凭证
# 用法:
#   ./scripts/secrets.sh encrypt <明文文件或字符串> <输出文件>
#   ./scripts/secrets.sh decrypt <加密文件>
#   ./scripts/secrets.sh gh-auth
#   ./scripts/secrets.sh baidu [field]
# 加密密码: 如需解密请向用户询问密码，不要硬编码或猜测

set -euo pipefail

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"


SECRETS_DIR="$(cd "$(dirname "$0")/.." && pwd)/.secrets"
mkdir -p "$SECRETS_DIR"

read_pass() {
  read -s -p "Enter encryption password: " ENCRYPT_PASS; echo
}

encrypt_token() {
  local token="$1"
  local outfile="${2:-$SECRETS_DIR/gh_token.enc}"
  echo -n "$token" | openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$ENCRYPT_PASS" -base64 > "$outfile"
  echo "Encrypted to: $outfile"
}

decrypt_token() {
  local infile="${1:-$SECRETS_DIR/gh_token.enc}"
  openssl enc -aes-256-cbc -d -pbkdf2 -pass pass:"$ENCRYPT_PASS" -base64 -in "$infile"
}

case "${1:-}" in
  encrypt)
    read_pass
    encrypt_token "$2" "$3"
    ;;
  decrypt)
    read_pass
    decrypt_token "$2"
    ;;
  gh-auth)
    read_pass
    decrypt_token | gh auth login --with-token
    echo "gh authenticated"
    ;;
  baidu)
    # 解密百度凭证，可指定字段: access_token, refresh_token, app_key, secret_key 等
    read_pass
    local json
    json=$(decrypt_token "$SECRETS_DIR/baidu_credentials.enc")
    if [ -n "$2" ]; then
      echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('$2',''))"
    else
      echo "$json"
    fi
    ;;
  *)
    echo "Usage: $0 {encrypt|decrypt|gh-auth|baidu}"
    echo ""
    echo "  encrypt <token> [outfile]  - Encrypt and save a token"
    echo "  decrypt [infile]           - Decrypt and print token"
    echo "  gh-auth                    - Decrypt token and auth gh"
    echo "  baidu [field]              - Decrypt Baidu credentials (optionally one field)"
    exit 1
    ;;
esac
