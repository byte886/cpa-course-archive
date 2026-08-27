# 开发文档索引

本文档索引 CPA 课程归档项目的所有技术开发文档，按专业领域分类。

## 文档列表

| 文档 | 说明 | 状态 |
|------|------|------|
| [git-workflow.md](./git-workflow.md) | GitHub工作流：SSH配置、代理设置、常见问题 | ✅ 已完成 |
| [video-processing.md](./video-processing.md) | 视频处理：下载、解密、压缩、验证 | ⏳ 待创建 |
| [transcription.md](./transcription.md) | 音频转文字：FunASR环境配置、性能数据、脚本使用 | ✅ 已完成 |
| [ocr.md](./ocr.md) | OCR文字提取：macOS Vision框架、PDF转图片、表格/图表AI补充 | ✅ 已完成 |
| [netdisk-setup.md](./netdisk-setup.md) | 百度网盘集成：应用创建、API配置、上传脚本 | ✅ 已完成 |
| [knowledge-base.md](./knowledge-base.md) | 知识库建设：飞书知识库结构、内容梳理、做题验证 | ⏳ 待创建 |
| [knowledge-base-organization.md](./knowledge-base-organization.md) | 知识库组织规范（AI友好）：Answer-First/原子结构/层级规范/MECE分类/FAQ优化/父页面规范 | ✅ 已完成 |
| [feishu-api.md](./feishu-api.md) | 飞书API使用注意事项：wiki节点删除/文档更新/权限设置/常见问题 | ✅ 已完成 |

## 技术栈

| 领域 | 技术/工具 |
|------|-----------|
| 视频下载 | Playwright + Node.js（HLS AES-128解密） |
| 视频压缩 | ffmpeg（H.265 CRF30） |
| 音频转文字 | FunASR SenseVoiceSmall（开源本地） |
| OCR | macOS Vision框架（系统原生）+ AI视觉补充 |
| 网盘 | 百度网盘开放平台API |
| 知识库 | 飞书知识库（Lark Wiki） |
| 任务管理 | 飞书多维表格（Base） |

## 脚本位置

> 所有脚本统一放在 `scripts/` 目录，详细说明见 [scripts/README.md](../../scripts/README.md)

| 脚本 | 位置 | 说明 |
|------|------|------|
| 视频下载解密 | `skill/scripts/download_decrypt.js` | HLS分片下载解密合并 |
| 视频压缩 | `skill/scripts/compress.sh` | ffmpeg批量压缩 |
| 网盘上传 | `scripts/baidu_upload.py` | 百度网盘分片上传 |
| 批量上传 | `scripts/batch_upload.sh` | 批量上传到网盘 |
| 音频转写 | `scripts/transcribe_pipeline.py` | FunASR单视频转写 |
| 批量转写 | `scripts/batch_transcribe.sh` | 批量转写（iTerm运行） |
| 批量OCR | `scripts/batch_ocr.sh` | 批量OCR（macOS Vision） |
| 密钥管理 | `scripts/secrets.sh` | 加密/解密工具 |
| 环境搭建 | `scripts/setup-*.sh` | 数据符号链接/转写环境 |
