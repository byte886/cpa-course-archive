# 脚本索引（Scripts Reference）

> **文档类型**：Reference（参考资料 — 脚本说明）
> **更新频率**：新增/修改脚本时
> **维护者**：AI自动维护
> **读者**：AI代理（执行任务前查脚本用途）和人类（了解脚本功能）

本文档是项目所有脚本的完整索引，按功能分类。每个脚本说明用途、用法、可靠性、相关文档。

---

## 脚本总览（20个）

| 分类 | 脚本数 | 说明 |
|------|--------|------|
| 做题自动化 | 3 | 单选题、多选题、交卷 |
| 视频处理 | 2 | 下载解密、压缩 |
| 音频转写 | 3 | 单文件转写、批量转写、环境搭建 |
| OCR文字提取 | 1 | 批量OCR |
| 百度网盘上传 | 3 | 单文件上传、批量上传、课程上传 |
| 环境与工具 | 4 | Playwright连接、密钥管理、数据符号链接、pre-commit |
| 检查与验证 | 3 | 目录结构检查、知识库结构检查、命名一致性巡检 |
| 数据采集 | 2 | 按键捕获、解析采集 |

---

## 一、做题自动化（3个）

### `answer_option.sh` — 单选题选项点击

| 项目 | 说明 |
|------|------|
| **用途** | 点击单选题的单个选项（A/B/C/D） |
| **用法** | `bash scripts/answer_option.sh C` |
| **可靠性** | ✅ 高（已验证，JavaScript直接点击，不依赖ref） |
| **相关文档** | `docs/development/guides/exam-workflow.md` |

**原理**：通过文本内容匹配选项元素，使用 `element.click()` 直接点击。过滤条件：文本精确匹配、元素可见、top>150（排除导航）、尺寸合理。

---

### `answer_multi.sh` — 多选题选项点击

| 项目 | 说明 |
|------|------|
| **用途** | 点击多选题的多个选项（可传多个参数） |
| **用法** | `bash scripts/answer_multi.sh A B D` |
| **可靠性** | ✅ 高（已验证，解决了ref失效问题） |
| **相关文档** | `docs/development/guides/exam-workflow.md` |

**注意**：多选题点击后不会自动跳题，需要手动点击"下一题"。

---

### `submit_exam.sh` — 交卷并查看成绩

| 项目 | 说明 |
|------|------|
| **用途** | 点击交卷按钮，等待成绩页面加载 |
| **用法** | `bash scripts/submit_exam.sh` |
| **可靠性** | ✅ 高（已验证） |
| **相关文档** | `docs/development/guides/exam-workflow.md` |

**注意**：交卷前必须检查所有题目已作答（打开答题卡确认无未做题）。

---

## 二、视频处理（2个）

### `download_decrypt.js` — HLS视频下载解密合并

| 项目 | 说明 |
|------|------|
| **用途** | 下载高顿网站HLS分片视频，AES-128解密，合并为完整MP4 |
| **用法** | `node scripts/download_decrypt.js <m3u8_url> <output.mp4>` |
| **可靠性** | ✅ 高（已验证，支持加密视频） |
| **相关文档** | `docs/development/tools/video-processing.md` |

**原理**：解析m3u8播放列表，下载所有.ts分片，使用AES-128密钥解密，ffmpeg合并为MP4。

---

### `compress.sh` — 视频批量压缩

| 项目 | 说明 |
|------|------|
| **用途** | 使用ffmpeg H.265 CRF30压缩视频，支持单文件和批量目录 |
| **用法** | `bash scripts/compress.sh <input.mp4> <output.mp4>` 或 `bash scripts/compress.sh <input_dir> <output_dir>` |
| **可靠性** | ✅ 高（已验证，压缩比约8:1） |
| **相关文档** | `docs/development/tools/video-processing.md` |

**参数**：libx265 / CRF 30 / preset fast / AAC 96k / hvc1标签 / faststart。
**验证**：压缩后自动检查时长误差<2秒、编码格式、可播放性。

---

## 三、音频转写（3个）

### `transcribe_pipeline.py` — 单视频音频转写

| 项目 | 说明 |
|------|------|
| **用途** | 从视频提取音频，使用faster-whisper/FunASR转写为文字 |
| **用法** | `python3 scripts/transcribe_pipeline.py <video.mp4> [output.md]` |
| **可靠性** | ✅ 中（依赖模型质量，专业术语可能出错） |
| **相关文档** | `docs/development/tools/transcription.md` |

**输出**：带时间戳的文字稿（Markdown格式）。

---

### `batch_transcribe.sh` — 批量视频转写

| 项目 | 说明 |
|------|------|
| **用途** | 批量转写目录下所有视频，在iTerm中运行可看实时进度 |
| **用法** | `bash scripts/batch_transcribe.sh <input_dir> <output_dir>` |
| **可靠性** | ✅ 中（依赖单文件转写的可靠性） |
| **相关文档** | `docs/development/tools/transcription.md` |

**注意**：必须在iTerm中运行（`bash scripts/batch_transcribe.sh`），不要在后台运行，方便查看进度和异常。

---

### `setup_transcription_env.sh` — 转写环境搭建

| 项目 | 说明 |
|------|------|
| **用途** | 创建Python虚拟环境，安装faster-whisper/FunASR及依赖 |
| **用法** | `bash scripts/setup_transcription_env.sh` |
| **可靠性** | ✅ 高（首次设置后不需要重复运行） |
| **相关文档** | `docs/development/tools/transcription.md` |

**输出**：`.venv-transcribe/` 虚拟环境目录（已在.gitignore中忽略）。

---

## 四、OCR文字提取（1个）

### `batch_ocr.sh` — 批量PDF/讲义OCR

| 项目 | 说明 |
|------|------|
| **用途** | 使用macOS Vision框架批量提取PDF中的文字，支持图片型PDF |
| **用法** | `bash scripts/batch_ocr.sh <pdf_dir> <output_dir>` |
| **可靠性** | ✅ 中高（macOS原生OCR，文字清晰时准确率高；表格/图表需AI补充） |
| **相关文档** | `docs/development/tools/ocr.md` |

**注意**：表格和图表中的文字OCR可能不完整，需要AI视觉模型补充识别。

---

## 五、百度网盘上传（3个）

### `baidu_upload.py` — 单文件上传到百度网盘

| 项目 | 说明 |
|------|------|
| **用途** | 使用百度网盘API分片上传单个文件 |
| **用法** | `python3 scripts/baidu_upload.py <local_path> <remote_path>` |
| **可靠性** | ✅ 高（已验证，支持大文件分片上传） |
| **相关文档** | `docs/development/api/netdisk-setup.md` |

**注意**：上传时不要通过代理（百度网盘API直连更快）。上传后验证文件大小与本地一致。

---

### `batch_upload.sh` — 批量文件上传

| 项目 | 说明 |
|------|------|
| **用途** | 批量上传目录下所有文件到百度网盘，保持目录结构 |
| **用法** | `bash scripts/batch_upload.sh <local_dir> <remote_dir>` |
| **可靠性** | ✅ 高（依赖baidu_upload.py） |
| **相关文档** | `docs/development/api/netdisk-setup.md` |

---

### `upload_course.sh` — 完整课程上传

| 项目 | 说明 |
|------|------|
| **用途** | 上传一个完整课程目录（视频+讲义+文字稿）到百度网盘对应位置 |
| **用法** | `bash scripts/upload_course.sh <course_name>` |
| **可靠性** | ✅ 中（依赖目录结构规范） |
| **相关文档** | `docs/development/api/netdisk-setup.md` |

---

## 六、环境与工具（4个）

### `playwright_connect.sh` — Playwright连接恢复

| 项目 | 说明 |
|------|------|
| **用途** | 检查Playwright连接状态，失败时自动刷新Token并重连 |
| **用法** | `bash scripts/playwright_connect.sh` |
| **可靠性** | ✅ 高（已验证，自动恢复流程） |
| **相关文档** | `docs/development/tools/playwright-cli-guide.md` 第4节 |

**注意**：连接失败时先运行此脚本自动恢复，**禁止直接要求用户手动操作**。

---

### `secrets.sh` — 加密凭证管理

| 项目 | 说明 |
|------|------|
| **用途** | 加密/解密敏感凭证（GitHub Token、百度网盘API密钥等） |
| **用法** | `bash scripts/secrets.sh encrypt <input> <output.enc>` 或 `bash scripts/secrets.sh decrypt <input.enc>` |
| **可靠性** | ✅ 高（OpenSSL AES-256加密） |
| **相关文档** | `docs/development/api/encryption.md` |

**规则**：加密文件（*.enc）可以提交到GitHub，明文文件（*.json, *.txt）在.gitignore中忽略。

---

### `setup_data_symlink.sh` — 数据目录符号链接

| 项目 | 说明 |
|------|------|
| **用途** | 创建/检查 `data/高顿/` 符号链接，指向外部数据目录（默认 `~/Desktop/高顿/`） |
| **用法** | `bash scripts/setup_data_symlink.sh`（创建）或 `bash scripts/setup_data_symlink.sh --check`（检查） |
| **可靠性** | ✅ 高（不同电脑可指向不同路径） |
| **相关文档** | `README.md` 存储分工部分 |

**注意**：`data/` 目录已在.gitignore中忽略，不会提交到GitHub。

---

### `pre-commit` — Git提交前检查

| 项目 | 说明 |
|------|------|
| **用途** | Git 提交前自动检查（检查项与阈值以 git-workflow 9.2 为准）：大文件 >1MB 警告 / >10MB 硬阻止；音视频、PDF 等生成文件误提交警告；敏感信息（明文 password/token/secret/key）警告；新增 .md 未登记 DOCUMENTATION_MAP 或缺头部类型标注警告；暂存 .md 相对链接断链硬阻止；文档类型词不在 7 类白名单（Task/Concept/Reference/Governance/Active/Knowledge/Template）硬阻止 |
| **用法** | 安装后每次 `git commit` 自动执行（激活副本位于 `.git/hooks/pre-commit`） |
| **可靠性** | ✅ 高（不依赖读文档，自动执行） |
| **相关文档** | `docs/development/guides/git-workflow.md` 第 9 节 |

**安装**：`cp scripts/pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`

---

## 七、检查与验证（3个）

### `check_directory_structure.sh` — 目录结构检查

| 项目 | 说明 |
|------|------|
| **用途** | 检查本地课程目录结构是否符合规范（高顿/CPA/课程库/课程名/章节名/） |
| **用法** | `bash scripts/check_directory_structure.sh <data_dir>` |
| **可靠性** | ✅ 中高（基于命名规范检查） |
| **相关文档** | `docs/project-management/standards/NAMING_CONVENTION.md` |

---

### `check_kb_structure.sh` — 知识库结构检查

| 项目 | 说明 |
|------|------|
| **用途** | 检查本地知识库文档结构是否符合规范（知识拆解.md + 考试指导.md） |
| **用法** | `bash scripts/check_kb_structure.sh <kb_dir>` |
| **可靠性** | ✅ 中（基于文件命名检查） |
| **相关文档** | `docs/development/knowledge/knowledge-base-organization.md` |

---

### `check_naming_consistency.py` — 命名一致性巡检 / 影响面 / 回归

| 项目 | 说明 |
|------|------|
| **用途** | 按 NAMING 第九章（SSOT）巡检"文档类型↔文件名风格"自洽、客观列出类型复核候选；对 task/test/verification/knowledge-base 下中文文件名提示"段间下划线、日期除外"；改名前 `--impact 老名` 查看引用影响面；整改后 `--regression` 跑自洽+断链回归。所有候选均为警告级、不阻断 |
| **用法** | `python3 scripts/check_naming_consistency.py`（另有 `--impact NAME` / `--regression`） |
| **可靠性** | ✅ 高（风格规则可机械判定；语义判型只列候选、通读后可维持原判，不臆断） |
| **相关文档** | `NAMING_CONVENTION.md` 第九章、`PROJECT_STRUCTURE_MAINTENANCE.md` 第六章 SOP |

---

## 八、数据采集（2个）

### `capture_key.js` — 按键捕获

| 项目 | 说明 |
|------|------|
| **用途** | 捕获页面中的加密密钥（用于HLS视频解密） |
| **用法** | `node scripts/capture_key.js <url>` |
| **可靠性** | ⚠️ 中（依赖页面结构，可能需要调整） |
| **相关文档** | `docs/development/tools/video-processing.md` |

---

### `collect_analysis.js` — 解析与用户留言采集

| 项目 | 说明 |
|------|------|
| **用途** | 从做题页面采集官方解析和用户留言精华 |
| **用法** | `node scripts/collect_analysis.js <exam_url>` |
| **可靠性** | ⚠️ 中（依赖页面结构，可能需要滚动加载） |
| **相关文档** | `docs/development/guides/exam-workflow.md` |

**注意**：用户留言可能需要向下滚动才能完整加载，脚本在"笔记"关键词处可能截断。

---

## 脚本使用原则

1. **先查本文档再用脚本**：执行任务前，先在本文档中找到对应脚本，了解用途、用法、可靠性
2. **优先用脚本，不手动写命令**：已有脚本的功能，必须用脚本，不要手动写JavaScript或curl
3. **做题必须用脚本**：`answer_option.sh` / `answer_multi.sh` / `submit_exam.sh`，禁止手动写ref点击
4. **批量任务在iTerm中运行**：`batch_transcribe.sh`、`batch_ocr.sh`、`compress.sh`（批量模式）必须在iTerm中运行，不要后台运行
5. **新增脚本必须更新本文档**：新增脚本时，必须在本文档对应分类中添加说明（用途/用法/可靠性/相关文档）

---

## 维护规则

1. **新增脚本时**：在本文档对应分类中添加条目，说明用途、用法、可靠性、相关文档
2. **修改脚本时**：更新本文档中对应条目的用法和可靠性说明
3. **删除脚本时**：从本文档中移除条目，并检查是否有其他文档引用该脚本
4. **定期检查**：每次大阶段完成后，检查本文档与实际脚本是否一致（`ls scripts/` 对比）

---

*本文档是项目脚本的唯一权威索引，所有新增/修改/删除脚本时必须同步更新。*
