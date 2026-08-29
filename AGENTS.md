# AGENTS.md — 高顿CPA课程归档项目

> **文档类型**：Governance（治理规范 — AI操作手册）
> **更新频率**：每次流程/工具/规范变更时
> **维护者**：AI自动维护 + 用户审核
> **读者**：AI代理（每次启动自动加载）

> 本文档是AI代理的操作手册，命令式、可执行。与README.md（给人看的项目介绍）互补。
> 每次启动会话时自动加载，执行任何任务前必须先阅读本文档对应部分。

---

## 文档边界

| 维度 | 本文档（AGENTS.md） | 其他文档 |
|------|---------------------|----------|
| **定位** | AI操作手册，命令式、可执行 | - |
| **读者** | AI代理（每次启动自动加载） | - |
| **包含** | 技术栈版本、设置命令、执行规则、Things to Avoid、异常处理 | - |
| **不包含** | 项目目标介绍、存储分工、课程列表 | → [README.md](README.md) |
| **不包含** | 详细操作流程、各环节步骤 | → [docs/WORKFLOW.md](docs/WORKFLOW.md) |
| **不包含** | 需求定义、功能清单、验收标准 | → [docs/REQUIREMENTS.md](docs/REQUIREMENTS.md) |
| **不包含** | 文档索引、所有文档清单 | → [docs/DOCUMENTATION_MAP.md](docs/DOCUMENTATION_MAP.md) |

---

## 1. Project Overview

高顿CPA课程归档项目：自动化完成高顿教育CPA课程的视频下载、压缩、转文字、知识库生成、做题验证全流程。

**核心目标**：将课程视频和讲义转化为结构化知识库，通过做题验证知识库质量，最终支持AI学习和考试辅导。

**使用者**：项目所有者（Mac环境），通过豆包AI代理执行自动化任务。

---

## 2. Tech Stack（版本锁定）

| 工具 | 版本 | 用途 |
|------|------|------|
| Python | 3.13.13 | 脚本开发（上传、转写管道） |
| Node.js | v20.20.2 | Playwright CLI运行环境 |
| ffmpeg | 8.1.2 | 视频压缩、音频提取 |
| Playwright CLI | latest | 浏览器自动化（高顿网站操作） |
| faster-whisper / FunASR | latest | 音频转文字 |
| 飞书API | - | 知识库、文档、多维表格 |
| 百度网盘API | - | 文件存储同步 |

**DO NOT** 自行升级以上工具版本，除非用户明确要求。版本变更可能导致脚本不兼容。

### 平台兼容性（重要）

> ⚠️ **项目主要在 macOS 下运行**，部分工具依赖 macOS 原生功能。执行任务前必须确认当前平台。

**Mac 专用工具（不可在其他平台直接使用）**：
- **macOS Vision 框架**：PDF/图片 OCR，必须用 `scripts/batch_ocr.sh`，**禁止安装 tesseract**
- **iTerm2**：批量任务必须在 iTerm 前台运行（实时进度），禁止后台运行
- **textutil**：DOC/DOCX 文字提取（macOS 原生命令）
- **AppleScript**：iTerm 窗口控制

**跨平台工具（可直接使用）**：
- ffmpeg、Playwright CLI、Node.js、Python、FunASR/faster-whisper、百度网盘API、飞书API

**如果在非 Mac 平台执行**：
1. OCR 必须替换为 Tesseract/PaddleOCR（需用户确认）
2. iTerm 相关脚本需调整为对应终端
3. bash 脚本可能需要调整（Mac 自带 bash 3.2，Linux 通常是 bash 4+）

**开发与测试环境（当前配置）**：

项目目前主要在以下 Mac 环境下开发和测试，执行任务前确认环境匹配：

- **操作系统**：macOS 15.7.8 (Sequoia)
- **硬件**：Mac Pro / Intel i5-13600KF 14核 / 128GB内存 / 3.7TB NVMe
- **Shell**：bash 3.2.57(1)-release（Mac自带版本，脚本基于此版本编写）
- **工具版本**：ffmpeg 8.1.2 / Node.js v20.20.2 / Python 3.13.13 / git 2.45.2 / Homebrew 6.0.19
- **浏览器**：Google Chrome（最新版，已登录高顿教育）
- **终端**：iTerm2（最新版，批量任务必须在此前台运行）

**环境检查命令**（开始任务前必跑）：
```bash
# 检查macOS版本
sw_vers

# 检查工具版本
ffmpeg -version | head -1
node --version
python3 --version
git --version

# 检查Chrome和iTerm是否安装
ls "/Applications/Google Chrome.app" >/dev/null 2>&1 && echo "Chrome OK"
ls "/Applications/iTerm.app" >/dev/null 2>&1 && echo "iTerm OK"
```

---

## 3. Setup Commands（精确命令）

### 3.1 环境检查（开始任务前必跑）

```bash
cd /Users/wenjiechen/Doubao/chats/2026-08-26/new-chat/gaodun_downloads

# 检查Playwright连接
npx playwright cli -s=ga tab-list

# 检查ffmpeg
ffmpeg -version | head -1

# 检查Python依赖
python3 -c "import faster_whisper" 2>/dev/null || echo "faster_whisper not installed"
```

### 3.2 常用操作命令

```bash
# 视频压缩（单文件）
bash scripts/compress.sh <input.mp4> <output.mp4>

# 批量视频压缩
bash scripts/compress.sh <input_dir> <output_dir>

# 音频转文字
bash scripts/setup-transcription-env.sh  # 首次设置
python3 scripts/transcribe_pipeline.py <audio.wav>

# 做题（使用脚本，不手动写JavaScript）
bash scripts/answer_option.sh <A/B/C/D>     # 单选题
bash scripts/answer_multi.sh <A> <B> <D>     # 多选题
bash scripts/submit_exam.sh                    # 交卷

# 百度网盘上传
python3 scripts/baidu_upload.py <local_path> <remote_path>

# OCR讲义
bash scripts/batch_ocr.sh <pdf_dir> <output_dir>
```

### 3.3 Playwright连接失败自动恢复

```bash
# 连接失败时，先刷新Token（参考 docs/development/tools/playwright-cli-guide.md 第4节）
# 禁止直接要求用户手动操作，先尝试自动恢复
bash scripts/playwright_connect.sh
```

---

## 4. Code Style（编码规范）

### 4.1 脚本规范

- **Shell脚本**：`#!/bin/bash`开头，`set -euo pipefail`，变量用双引号
- **Python脚本**：类型注解，函数式优先，避免全局状态
- **文件名**：`kebab-case.sh` / `snake_case.py`，功能名清晰
- **所有脚本放 `scripts/` 目录**，禁止散落在各子目录

### 4.2 文档规范

- **Markdown格式**，标题层级清晰（# → ## → ###）
- **命令用代码块**，路径用反引号
- **每个文档开头标注类型**：`> 文档类型：Task / Concept / Reference / Governance`
- **WORKFLOW.md只放流程概览和链接**，详细内容放专项文档

### 4.3 命名规范

- 课程目录：`高顿/CPA/课程库/<课程名>/<章节名>/`
- 视频文件：`video.mp4`（统一命名，不保留原始长文件名）
- 讲义目录：`docs/`
- 知识库文档：`知识拆解.md` / `考试指导.md`

---

## 5. Testing Instructions（验证指南）

### 5.1 视频压缩验证

```bash
# 验证视频可播放、时长一致
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 <output.mp4>
# 时长与原片误差 <2秒为合格
```

### 5.2 转文字验证

- 抽样检查3-5段文字稿，确认无明显错字、断句合理
- 专业术语（如"消费税"、"从价定率"）必须正确

### 5.3 做题验证

- 交卷后检查正确率，错题必须区分"知识错误"和"交互错误"
- 交互错误必须修复脚本/流程，知识错误必须检查知识库是否有误

### 5.4 上传验证

- 上传后检查文件大小与本地一致
- 检查目录结构与规划一致

---

## 6. Architecture Notes（架构说明）

### 6.1 目录结构逻辑

```
gaodun_downloads/
├── AGENTS.md              # 本文档（AI操作手册）
├── README.md              # 项目介绍（给人看）
├── scripts/               # 所有可执行脚本（统一管理）
├── docs/
│   ├── WORKFLOW.md        # 主工作流（概览+链接）
│   ├── development/       # 专项技术文档（工具/流程/API）
│   ├── project-management/ # 项目管理（规范/状态/测试计划）
│   └── knowledge-base/    # 知识库（模板/方法论/整理内容/原始素材）
├── data/                  # 数据目录（软链接到 ~/Desktop/高顿/）
├── output/                # 临时输出（测试用，不上传）
├── reports/               # 任务报告
└── transcription/         # 转写中间文件（.gitignore）
```

### 6.2 存储分工（硬约束）

| 位置 | 内容 | 说明 |
|------|------|------|
| GitHub仓库 | 代码+文档 | **禁止**放视频、PDF、文字稿等生成结果 |
| 本地 `~/Desktop/高顿/` | 视频、讲义、文字稿 | 生成结果的主存储 |
| 百度网盘 | 与本地完全镜像 | 备份+跨设备访问 |
| 飞书知识库 | 知识梳理内容 | 结构化知识，面向学习 |
| 飞书文档 | 任务报告 | 过程记录 |

### 6.3 文档分工

- `docs/WORKFLOW.md` — 主工作流（只放流程概览和链接，不放详细内容）
- `docs/development/*.md` — 专项技术文档（工具使用、API、流程细节）
- `docs/project-management/*.md` — 项目管理（规范、状态、测试计划）
- `docs/development/templates/` — 知识库模板
- `docs/development/knowledge/` — 知识库方法论（组织规范、来源清单）
- `knowledge-base/organized-content/` — 整理后的知识内容（知识拆解、考试指导）
- `knowledge-base/source-materials/` — 原始素材（做题记录、解析、用户笔记）

---

## 7. Things to Avoid（明确禁止事项）

### 7.1 操作禁止

- ❌ **不要用Chrome浏览器手动下载文件**——必须用脚本（`scripts/download_decrypt.js`或curl）后台下载
- ❌ **不要在一个Bash命令中做多道题**——每个命令只做一道题，避免超时移到后台导致输出丢失
- ❌ **不要用ref点击多选题的第二个及以后选项**——ref会失效，必须用 `scripts/answer_multi.sh`（JavaScript直接点击）
- ❌ **不要跳过"做题前查询知识库"步骤**——必须先读对应知识库文档再答题
- ❌ **不要自行关闭用户打开的Chrome窗口**——只关闭Playwright管理的多余tab页

### 7.2 文档禁止

- ❌ **不要把详细技术内容写到WORKFLOW.md**——WORKFLOW只放概览和链接
- ❌ **不要不检查已有文档就新建文档**——先用 `grep -r "关键词" docs/` 查找
- ❌ **不要把交互规范写到技术文档中，或把技术规范写到交互文档中**
- ❌ **不要新增内容后不更新相关文档的链接**

### 7.3 流程禁止

- ❌ **不要不查阅文档就直接执行**——必须先读AGENTS.md → README.md → WORKFLOW.md对应环节 → 专项文档
- ❌ **不要操作失败就直接要求用户手动操作**——必须先查文档、尝试自动修复，无法解决再请求帮助
- ❌ **不要大任务不创建执行状态记录就开始**——批量>3个讲次或预计>1小时必须先创建状态记录
- ❌ **不要把生成结果（视频/PDF/文字稿）提交到GitHub**——.gitignore已忽略，不要强制添加

---

## 8. 执行前必读文档（强制顺序）

**执行任何任务前，必须按以下顺序查阅文档，未查阅不得开始执行：**

1. **先读 `README.md`** — 了解项目概览、存储分工、核心原则
2. **再读 `docs/WORKFLOW.md` 对应环节** — 找到当前任务所属的流程环节，阅读详细步骤
3. **按 WORKFLOW 中的「参考文档」链接查阅专项文档** — 如做题交互规范、压缩参数说明等
4. **最后检查 `docs/project-management/active/TASK_STATUS.md`** — 确认当前任务状态和前置依赖

**为什么必须这样做**：本项目流程复杂，每个环节都有专项文档记录了踩过的坑和优化方案。不查阅文档直接执行，大概率会重复犯之前已经解决过的错误。文档是项目的"集体记忆"，必须依赖文档而不是对话记忆。

---

## 9. 浏览器操作任务强制检查清单

**开始任何需要浏览器操作的任务前，必须按以下清单逐项检查：**

| 序号 | 检查项 | 检查方法 | 处理方式 |
|------|--------|----------|----------|
| 1 | 关闭无关tab页 | `npx playwright cli -s=ga tab-list` | 超过2个tab时，关闭除工作页面外的所有页面 |
| 2 | 检查Playwright连接状态 | `npx playwright cli -s=ga tab-list` | 如果报错，执行连接恢复流程 |
| 3 | 连接失败自动刷新Token | 连接超时或报错 | 按 `docs/development/tools/playwright-cli-guide.md` 第4节自动刷新，**禁止直接要求用户手动操作** |
| 4 | 检查当前页面是否正确 | `npx playwright cli -s=ga eval "() => window.location.href"` | 如果不是目标页面，导航到正确URL |
| 5 | 检查任务前置依赖 | 查看 `TASK_STATUS.md` | 确认前置任务已完成 |

---

## 10. 异常处理流程（任何操作失败时）

**任何操作失败时，必须按以下流程处理，禁止直接要求用户手动操作：**

1. **先检查文档中是否有解决方案**：用 `grep -rn "关键词" docs/` 搜索相关文档
2. **按文档中的解决方案尝试自动修复**：如连接失败→自动刷新Token；命令卡住→按分级处理流程恢复
3. **如果文档中没有解决方案**：先尝试通用故障排除方法（重启进程、清理缓存、检查网络），仍然无法解决时再请求用户帮助，并说明已尝试的方法

### 常见异常的自动处理

| 异常情况 | 自动处理方式 | 参考文档 |
|----------|-------------|----------|
| Playwright连接失败 | 自动刷新Token后重连 | playwright-cli-guide.md 第4节 |
| 命令卡住/超时 | 检查session→刷新页面→重连 | interaction-workflow.md 第4.5节 |
| 页面元素找不到 | 等待页面加载→刷新页面→检查选择器 | interaction-workflow.md |
| 脚本执行报错 | 查看错误日志→检查依赖→按文档修复 | 对应脚本的README |

---

## 11. 文档快速入口

按任务类型查找文档：

| 任务类型 | 先看 | 再看 |
|----------|------|------|
| 视频下载/压缩 | `docs/WORKFLOW.md` 第2节 | `docs/development/tools/video-processing.md` |
| 文档下载 | `docs/WORKFLOW.md` 第3节 | - |
| 百度网盘同步 | `docs/WORKFLOW.md` 第4节 | `docs/development/api/netdisk-setup.md` |
| 视频转文字 | `docs/WORKFLOW.md` 第5节 | `docs/development/tools/transcription.md` |
| 知识库生成 | `docs/WORKFLOW.md` 第6节 | `docs/development/knowledge/knowledge-base-organization.md` |
| **做题验证** | `docs/WORKFLOW.md` 第7节 | **`docs/development/guides/exam-workflow.md`** |
| 任务报告 | `docs/WORKFLOW.md` 第8节 | `docs/project-management/README.md` |
| Git操作 | `docs/development/guides/git-workflow.md` | - |
| 项目维护 | `docs/project-management/standards/PROJECT_MAINTENANCE.md` | - |

---

## 11.5 状态查询协议（收到用户查询时必须遵守）

当用户询问项目状态、任务、问题、维护工作等信息时，**必须先参考 [PROJECT_STATUS_QUERY.md](docs/project-management/standards/PROJECT_STATUS_QUERY.md) 识别查询意图**，再读取对应文档，按标准格式响应。

**6类查询意图：**
- Q1 任务状态查询 → 读 `TASK_STATUS.md`
- Q2 问题/BUG查询 → 读问题列表（从TASK_STATUS和验证报告提取）
- Q3 维护工作查询 → 读 `PROJECT_MAINTENANCE.md` + 待优化项
- Q4 文档/操作查询 → 读 `DOCUMENTATION_MAP.md` + `WORKFLOW.md`
- Q5 项目概览查询 → 读 `README.md` + `TASK_STATUS.md`
- Q6 决策/历史查询 → 读 `docs/project-management/decisions/`（ADR）

**关键规则：**
- 用户表达模糊时，根据映射表识别意图，**不要猜测**
- 如果映射到多个意图，**主动询问**用户想了解哪方面，给出2-3个选项
- 按标准响应格式回答，结构化呈现
- 完整映射表和响应格式见 [PROJECT_STATUS_QUERY.md](docs/project-management/standards/PROJECT_STATUS_QUERY.md)

---

## 12. 项目特定规则

### 12.1 问题驱动更新（强制）

发现任何问题（文件位置不对、脚本有bug、流程有缺陷、文档缺失等）时，必须立即评估是否需要更新文档或自动化检查，评估后必须执行，不能只发现问题不更新。

### 12.2 小问题顺手修复，大问题讨论处理

- **小问题**（文档链接错误、文件名不对、简单脚本bug）：顺手修复，并记录到任务报告
- **大问题**（流程变更、架构调整、新增功能）：先和用户讨论，确认方案后再执行

### 12.3 定期检查项目结构

每次开始新任务前、完成大任务后，必须检查项目结构是否合理，发现问题主动梳理调整。

### 12.4 写文档前必须检查文档组织（强制）

**遇到问题需要写文档、更新文档或新增内容时，必须先检查项目文档组织和分工，禁止直接写到任意文档中。**

**检查流程**：
1. 查看文档目录结构：`ls -la docs/`
2. 查找相关文档：用 `grep -r "关键词" docs/` 查找是否已有相关内容
3. 确认文档分工（见第6.3节）
4. 选择正确的文档，WORKFLOW.md只放摘要和链接
5. 确保文档关联：新增或更新后，确保相关文档之间有链接

### 12.5 文档同步规则（强制）

每次完成阶段性任务、生成新文档、或变化项目结构时，必须按 `docs/project-management/DOC_SYNC_CHECKLIST.md` 检查并同步相关文档。

**同步时机**：完成单个讲座流程后 / 完成所有试卷后 / 发现问题并解决后 / 项目结构调整后 / 大阶段完成后

**核心原则**：本地文档为主，飞书表格为辅；问题驱动更新，发现问题立即评估是否需要更新文档。

### 12.6 大任务执行状态记录（强制）

**开始任何大任务前，必须先创建执行状态记录，异常恢复时必须先读取状态记录。**

**详细规范**：`docs/project-management/standards/BATCH_TASK_EXECUTION.md`

**必须创建执行状态记录的场景**：
1. 批量处理 >3 个讲次
2. 预计执行时间 >1 小时
3. 涉及多个工具链（Playwright + ffmpeg + FunASR + 飞书API等）
4. 用户明确要求"批量处理"、"全部完成"

### 12.7 清理原则

- 测试文件、临时日志、残留目录及时清理
- 完成任务后检查是否有中间产物需要清理
- 不要在项目根目录散落临时文件

---

## 13. Definition of Done（任务完成标准）

任务完成前，必须逐项验证：

- [ ] 所有生成文件已验证可用（视频可播放、文字稿无明显错误、知识库内容准确）
- [ ] 所有错题已分析原因（知识错误→检查知识库，交互错误→修复脚本）
- [ ] 相关文档已同步（按DOC_SYNC_CHECKLIST.md检查）
- [ ] 临时文件已清理
- [ ] 任务状态已更新（TASK_STATUS.md）
- [ ] 生成结果已上传到对应位置（本地+百度网盘+飞书知识库，按存储分工）

---

*本文档随项目演进持续更新。发现规则缺失或不准确时，按"问题驱动更新"原则立即补充。*
