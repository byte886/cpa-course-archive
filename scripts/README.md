# 脚本说明

本目录存放项目所有可执行脚本（Python、Shell），统一管理，不分散在各子目录。

## 脚本清单

| 脚本 | 类型 | 用途 | 用法 |
|------|------|------|------|
| `baidu_upload.py` | Python | 百度网盘分片上传大文件（4MB分片，MD5秒传） | `BAIDU_ENC_PASS=<密码> python3 scripts/baidu_upload.py <本地文件> <网盘路径>` |
| `batch_upload.sh` | Shell | 批量上传视频到百度网盘（iTerm运行，断点续传） | `bash scripts/batch_upload.sh` |
| `upload_course.sh` | Shell | 课程目录批量上传（自动过滤技术过程文档，递归遍历目录） | `bash scripts/upload_course.sh <本地课程目录> <网盘课程目录>` |
| `transcribe_pipeline.py` | Python | 单视频音频转文字（FunASR + VAD，输出transcript.md/json） | `python3 scripts/transcribe_pipeline.py <视频路径> <输出目录>` |
| `batch_transcribe.sh` | Shell | 批量视频转写（iTerm运行，自动依次处理，断点续传） | `bash scripts/batch_transcribe.sh` |
| `batch_ocr.sh` | Shell | 批量PDF OCR（macOS Vision框架，输出合并Markdown） | `bash scripts/batch_ocr.sh` |
| `secrets.sh` | Shell | 密钥加密/解密工具（AES-256-CBC，GitHub Token和百度网盘凭证） | `./scripts/secrets.sh encrypt/decrypt/gh-auth/baidu` |
| `setup-data-symlink.sh` | Shell | 创建/调整 data/高顿 符号链接（跨电脑数据目录路径不同） | `./scripts/setup-data-symlink.sh [路径] [--check]` |
| `setup-transcription-env.sh` | Shell | 新电脑一键搭建音频转写环境（FunASR虚拟环境） | `./scripts/setup-transcription-env.sh [Python版本] [--check]` |
| `pre-commit` | Shell | Git pre-commit hook源文件（大文件/敏感信息检查） | 复制到 `.git/hooks/pre-commit` 生效 |
| `capture_key.js` | JavaScript | Playwright注入Worker hook捕获HLS AES密钥（SD/FHD） | `npx playwright cli -s=<session> run-code scripts/capture_key.js` |
| `download_decrypt.js` | JavaScript | 下载HLS分片并AES-128解密合并为.ts文件 | `node scripts/download_decrypt.js <m3u8路径> <输出.ts> <分片目录> <key> <iv> [并发数]` |
| `compress.sh` | Shell | ffmpeg压缩.ts为H.265 MP4（CRF30，iTerm显示进度） | `bash scripts/compress.sh <input.ts> <output.mp4> [crf]` |
| `playwright_connect.sh` | Shell | Playwright连接脚本（自动检测并处理连接确认） | `bash scripts/playwright_connect.sh` |

## 脚本分类

### 视频下载与处理
- `capture_key.js` - 捕获HLS AES密钥（Playwright Worker hook注入）
- `download_decrypt.js` - 下载分片并解密合并（Node.js，AES-128-CBC）
- `compress.sh` - ffmpeg压缩为H.265 MP4（CRF30，iTerm显示进度）
- `transcribe_pipeline.py` - 单视频转写（核心逻辑）
- `batch_transcribe.sh` - 批量转写（调用 transcribe_pipeline.py，循环处理）
- `batch_ocr.sh` - 批量OCR（讲义文档）

### 百度网盘
- `baidu_upload.py` - 单文件分片上传（核心逻辑，4MB分片+MD5秒传）
- `batch_upload.sh` - 批量上传视频（调用 baidu_upload.py，循环处理多个视频）
- `upload_course.sh` - 课程目录批量上传（递归遍历目录，自动过滤技术过程文档）

> **文件过滤原则**：`upload_course.sh` 自动过滤技术过程文档（VERIFICATION_*.md、transcript.json、*.tmp、*.log），只上传面向使用者的内容。详细原则见 [PROJECT_MAINTENANCE.md 第九章](../docs/project-management/standards/PROJECT_MAINTENANCE.md)。

> **单文件+批量分工模式**：核心逻辑用 Python（功能强、可复用），批量调度用 Shell（简单、支持断点续传、iTerm显示进度）。同样的模式还有 `transcribe_pipeline.py` + `batch_transcribe.sh`。

### 环境与配置
- `setup-data-symlink.sh` - 数据符号链接（跨电脑数据目录路径不同）
- `setup-transcription-env.sh` - 转写环境搭建（新电脑一键创建FunASR虚拟环境）
- `secrets.sh` - 密钥管理（加密/解密GitHub Token和百度网盘凭证）

### Git 钩子
- `pre-commit` - pre-commit hook源文件（大文件/敏感信息检查，复制到.git/hooks/生效）

## 运行方式

### iTerm 运行（推荐，可看进度）
批量脚本（batch_*.sh）建议在 iTerm 中运行，可实时查看进度：
```bash
cd /path/to/project
bash scripts/batch_transcribe.sh
```

### 后台运行
单文件脚本可后台运行：
```bash
nohup python3 scripts/baidu_upload.py file.mp4 /path/ > /tmp/upload.log 2>&1 &
```

### 环境检查
```bash
./scripts/setup-data-symlink.sh --check
./scripts/setup-transcription-env.sh --check
```

## 依赖说明

| 脚本 | 依赖 | 安装方式 |
|------|------|----------|
| `baidu_upload.py` | Python3, requests | `pip install requests` |
| `transcribe_pipeline.py` | Python3, funasr, torch | `./scripts/setup-transcription-env.sh` |
| `batch_ocr.sh` | macOS, Vision框架, pdftoppm | 系统自带 + `brew install poppler` |
| `secrets.sh` | openssl | 系统自带 |
| `setup-*.sh` | bash, python3 | 系统自带 |

## 相关文档

| 脚本 | 详细文档 |
|------|----------|
| `baidu_upload.py`, `batch_upload.sh` | [docs/development/netdisk-setup.md](../docs/development/netdisk-setup.md) |
| `transcribe_pipeline.py`, `batch_transcribe.sh` | [docs/development/transcription.md](../docs/development/transcription.md) |
| `batch_ocr.sh` | [docs/development/ocr.md](../docs/development/ocr.md) |
| `secrets.sh` | [docs/development/encryption.md](../docs/development/encryption.md) |
| `pre-commit` | [docs/development/git-workflow.md](../docs/development/git-workflow.md) |
| `capture_key.js`, `download_decrypt.js`, `compress.sh` | [docs/development/video-processing.md](../docs/development/video-processing.md) |
| `playwright_connect.sh` | [docs/development/playwright-cli-guide.md](../docs/development/playwright-cli-guide.md) |

## 注意事项

1. **批量脚本支持断点续传**：已完成的文件会自动跳过，不完整的会重新处理
2. **密钥不硬编码**：`secrets.sh` 解密时需要用户提供密码，不要硬编码
3. **路径使用相对路径**：脚本中统一使用项目相对路径，避免硬编码绝对路径
4. **新增脚本时**：必须在本文档中添加说明，包括用途、用法、依赖、相关文档
