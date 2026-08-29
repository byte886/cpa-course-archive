# 高顿 Glive HLS 加密逆向分析

> **文档类型**：Reference（参考资料）
> **更新频率**：API变更时
> **维护者**：AI自动维护
> **读者**：AI代理

## 加密架构

```
m3u8 (#EXT-X-KEY: AES-128, authorize URL, IV)
  ↓
.ts 分片（公开可下载，AES-128-CBC 加密）
  ↓
authorize 接口 → 92 字节 base64 密文
  ↓
hls.js Worker postMessage({type:"decrypt", data:{decryptdata, prikey, pubkey, sysTime}})
  ↓
主线程 WASM parse_decrypt() / CryptoJS Pn() 解密
  ↓
Worker 收到 32 字节响应 → 前 16 字节 = AES key (ASCII)
  ↓
AES-128-CBC 解密 .ts 分片
```

## 密钥提取方法（已验证）

不需要复现 WASM 解密算法。通过 hook Worker 构造函数，包装 `postMessage` 和 `addEventListener`，直接截获 Worker 与主线程之间的通信：

1. `addInitScript` 注入 hook（必须在页面任何脚本执行前）
2. reload 页面
3. 视频播放时 Worker 创建，hook 自动记录所有消息
4. 切换 FHD 清晰度会触发第二个 initHls 和第二个 decrypt 响应
5. 从 `to_worker` 消息中找 `msg.response`（32 字节数组）
6. 前 16 字节转 ASCII 字符串即为 AES key

## 密钥格式

Worker 返回 32 字节，例如：
```
[52,98,52,52,54,100,48,100,98,53,57,53,52,101,50,98, ...]
```

前 16 字节 ASCII = `"4b446d0db5954e2b"`（16 字符）

**关键**：这 16 字节直接作为 AES key 的原始字节，不要做 hex 解码。hls.js 的软件 AES 实现 `uint8ArrayToUint32Array_` 固定创建 `Uint32Array(4)` 只读前 16 字节。

## 解密参数

- 算法：AES-128-CBC
- key：Worker decrypt 响应前 16 字节的原始 ASCII
- IV：m3u8 中 `IV=0x...` 的 hex 值（所有分片相同）
- padding：`setAutoPadding(false)`（TS 分片无 PKCS7 填充）
- 每个分片独立解密，不链式

## 验证方法

解密后首字节应为 `0x47`（MPEG-TS sync byte），每 188 字节重复一次。

## 已验证的死路

- 新浏览器模式需登录（被重定向到 v.gaodun.com）
- WebCrypto hook 不触发（Worker 内用软件 AES）
- WASM hook 未捕获到 parse_decrypt
- 直接 curl authorize 返回 403（需要 bellard 时间戳 + cookie）
- Node.js 复现 CryptoJS Pn 算法报 bad decrypt
- Extension 模式下 CDP "Not allowed"
- AES-256-CBC / hex 解码密钥均失败

## 关键 JS 文件

- 自定义 hls.js Worker：`https://gd-file.gaodun.com/glive2-player/2.3.1-release-l2/hls.min.js?v=2.3.0-l2`
- 播放器 SDK：`https://sub-study-player.gaodun.com/static/js/951.43a9c9d.js`
- 主播放器：`https://sub-study-player.gaodun.com/static/js/index.3d394ce.js`
