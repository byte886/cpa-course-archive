---
name: gaodun-course-downloader
description: "高顿 Glive 课程回放视频下载、解密、压缩与归档。支持 HLS AES-128 加密视频的密钥提取（通过 Playwright 注入 Worker hook）、1080P FHD 分片下载解密合并、H.265 压缩、讲义文档下载、百度网盘上传。当用户提到高顿、gaodun、glivepro、课程回放下载、CPA 课程视频、蔡俊峻、罗翔等关键词时使用。"
---

# 高顿 Glive 课程下载器

从 glivepro.gaodun.com 下载课程回放视频（HLS AES-128 加密），解密合并后压缩为 H.265 MP4，并归档讲义文档。

## 前置条件

1. **Playwright Extension 模式**：用户 Chrome 已安装 Playwright Extension 并提供 token（见 playwright skill）
2. **Node.js**：用于下载解密脚本
3. **ffmpeg**：`/usr/local/bin/ffmpeg`，需支持 libx265
4. **iTerm2**：压缩命令在 iTerm 窗口中运行，用户可直接看进度

## 加密方案（核心知识）

- 视频为标准 HLS，m3u8 含 `#EXT-X-KEY:METHOD=AES-128,URI=".../replay/authorize?...",IV=0x...`
- .ts 分片可公开下载，但内容是 AES-128-CBC 加密
- 密钥获取链路：authorize 接口返回 92 字节密文 → hls.js Worker 发 `postMessage({type:"decrypt",...})` 给主线程 → 主线程 WASM 解密 → 返回 32 字节响应
- **实际 AES key = 响应前 16 字节的原始 ASCII 字符串**（不是 hex 解码）
- IV 直接取自 m3u8 的 `IV=0x...`
- 每个分片用相同 IV 独立解密（标准 HLS 行为），`setAutoPadding(false)`

详细逆向分析见 [references/encryption.md](references/encryption.md)。

## 完整工作流

### 1. 连接浏览器

```bash
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach --extension=chrome
```

### 2. 打开课程表并遍历回放

课程表 URL 格式：`https://glivepro.gaodun.com/course/<course_id>/class-schedule`

- 用 `snapshot`/`find` 找到"看回放"按钮
- **跳过"开班典礼"**（标题含"开班典礼"的场次）
- 点击"看回放"会在新标签页打开播放器（`v-glive.gaodun.com/player?token=...`）
- 切换到新标签页：`npx playwright cli -s=ga tab-select 1`

### 3. 捕获 FHD 密钥

在播放器标签页运行 capture_key.js（注入 Worker hook → reload → 播放 → 切换 1080P → 提取密钥）：

```bash
npx playwright cli -s=ga run-code scripts/capture_key.js
```

返回 JSON 包含 `streams` 数组，每项有 `quality`、`m3u8`、`keyAscii`。取 `FHD-1080P` 项。

**注意**：
- 自定义元素标签名（如 `G-3F001E35`）每次加载会变，通过 `.gp-video-wrap` 子元素遍历找 `.video` 属性
- 清晰度按钮 class：`.gp-setting-quality-item`，FHD 选项文本含"1080"
- 如果 FHD 切换后没有新密钥，检查视频是否已在播放（需 seek 到 0 并 play）

### 4. 下载 m3u8 和分片

```bash
# 下载 FHD m3u8
curl -s -o playlist.m3u8 "<fhd_m3u8_url>" \
  -H "User-Agent: Mozilla/5.0 ..." -H "Referer: https://v-glive.gaodun.com/"

# 下载+解密+合并全部分片（20并发，支持断点续传）
node scripts/download_decrypt.js playlist.m3u8 merged.ts ./segments <keyAscii> <iv_hex> 20
```

IV 从 m3u8 的 `#EXT-X-KEY` 行提取，去掉 `0x` 前缀。

### 5. 压缩（在 iTerm 中运行，显示实时进度）

```bash
# 在 iTerm 新标签页中运行（用户可见 ffmpeg 实时进度）
osascript -e "tell application \"iTerm\"
  tell current window
    create tab with default profile
    tell current session
      write text \"cd '<output_dir>'; bash '<skill_dir>/scripts/compress.sh' merged.ts video.mp4 30\"
    end tell
  end tell
end tell"
```

压缩参数：H.265 CRF 30（课件文字清晰、头像略糊但不影响学习）、AAC 96k、hvc1 标签、faststart。
压缩完成后 compress.sh 自动验证时长和可播放性。

### 6. 下载讲义文档

在课程表页，每个直播场次下有"讲义|"/"课件|"前缀的条目，带"下载"链接。

```bash
# 在浏览器中提取下载链接
npx playwright cli -s=ga eval "
(() => {
  const items = document.querySelectorAll('.gp-classmate-item, [class*=material]');
  // 遍历找到含'下载'的元素，提取 href 或 onclick 中的 URL
  ...
})()
"
```

下载 PDF 到对应场次的 `docs/` 子目录。

### 7. 目录结构

```
<download_root>/
├── 税法-蔡俊峻/
│   ├── 01_税法全面精讲01-税法总论/
│   │   ├── video.mp4          # 压缩后视频
│   │   ├── playlist.m3u8      # m3u8 备份
│   │   ├── segments/          # 解密分片缓存（可删除）
│   │   ├── merged.ts          # 合并后原始TS（可删除）
│   │   └── docs/              # 讲义课件 PDF
│   ├── 02_.../
│   └── ...
├── 会计-罗翔/
│   └── ...
└── _reports/                  # 任务报告
```

### 8. 验证清单

每个视频压缩后必须确认：
- [ ] ffprobe 能正常读取（moov atom 存在）
- [ ] 输出时长与输入时长差 < 2 秒
- [ ] 视频编码为 hevc，分辨率 1920x1080
- [ ] 音频编码为 aac
- [ ] 文件可正常播放（首尾都有画面）

### 9. 百度网盘上传（可选）

百度网盘开放平台 REST API 支持文件上传、目录管理（mkdir/move/delete/rename）。
配置和使用见 [references/baidupan.md](references/baidupan.md)。

## 关键陷阱

1. **Extension 模式下 CDP 不可用**（"Not allowed"），只能用 Playwright CLI 命令
2. **Worker hook 必须在 reload 前注入**（addInitScript），否则 Worker 已创建无法拦截
3. **密钥不是 hex 解码**：Worker 返回 32 字节 ASCII hex 字符串，但 hls.js 只读前 16 字节原始字节作为 AES key
4. **m3u8 token 会过期**：批量下载时需定期重新打开播放器获取新 token
5. **每个视频密钥不同**：必须逐个捕获，不能复用
6. **ref 是动态的**：每次页面变化后重新 snapshot/find
7. **播放器自定义元素在 closed shadow DOM 内**：通过 `.gp-video-wrap` 子元素的 `.video` 属性访问
