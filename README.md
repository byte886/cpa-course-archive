# 高顿 CPA 课程智能归档项目

> **文档类型**：Concept（概念说明 — 项目介绍）
> **更新频率**：项目结构/课程/存储分工变更时
> **维护者**：AI自动维护 + 用户审核
> **读者**：人类（新加入项目者）和AI（首次了解项目时）

---

## 文档边界

| 维度 | 本文档（README.md） | 其他文档 |
|------|---------------------|----------|
| **定位** | 项目介绍，给人看的概览 | - |
| **读者** | 人类（新加入项目者）和AI（首次了解项目时） | - |
| **包含** | 项目目标、仓库地址、常用查询话术、课程列表、存储分工、目录结构 | - |
| **不包含** | AI执行规则、命令、Things to Avoid | → [AGENTS.md](AGENTS.md) |
| **不包含** | 详细操作流程、各环节步骤 | → [docs/WORKFLOW.md](docs/WORKFLOW.md) |
| **不包含** | 需求定义、功能清单、验收标准 | → [docs/REQUIREMENTS.md](docs/REQUIREMENTS.md) |
| **不包含** | 文档索引、所有文档清单 | → [docs/DOCUMENTATION_MAP.md](docs/DOCUMENTATION_MAP.md) |

---

把在线课程变成你自己的、可搜索、可问答、永久保存的备考资产。

最终你会得到：

1. **一个永不失效的课程资料库** — 所有购买的 CPA 课程视频和讲义保存在本地和百度网盘，平台到期也能看
2. **一个可搜索的个人知识库** — 视频里老师讲的、讲义上写的，全部变成文字，按课程章节组织在飞书知识库里，随时搜得到
3. **一个会做题的备考助手** — 学完直接做课后练习，知识库帮你找答案、对依据、查漏补缺

## 仓库地址

- GitHub: https://github.com/byte886/cpa-course-archive （公有）

## 常用查询话术（直接复制使用）

想了解项目状态时，直接复制下面的话术发送给AI：

| 你想知道 | 直接复制 |
|----------|----------|
| 还有哪些任务要做 | `查询任务状态：还有哪些待完成的任务？` |
| 有什么问题/BUG | `查询问题：当前有哪些未解决的问题或BUG？` |
| 需要做什么维护 | `查询维护：当前有哪些待完成的维护工作？` |
| 项目整体进度 | `查询概览：给我一个项目整体状态的总结` |
| 为什么这样做 | `查询历史：为什么[某个决策]是这样做的？` |
| **刷新Playwright token** | `刷新Playwright token` |
| 不确定想查什么 | `我想了解项目状态，请给我几个选项让我选择` |

**完整速查表**：[PROJECT_STATUS_QUERY.md](docs/project-management/standards/PROJECT_STATUS_QUERY.md) 第零节

## 课程

- 【26考季】VIPCPA系列-税法（蔡俊峻老师）— 39场直播（跳过开班典礼后38场）
- 【26考季】VIPCPA系列-会计（罗翔老师）— 待采集
- 【26考季】VIPCPA-基础必修-会计（罗翔老师）— 12讲（手工录制视频）

## 存储分工

| 位置 | 内容 |
|------|------|
| GitHub 仓库 | Skill 代码、需求文档、工作流、项目计划、报告模板、加密凭证 |
| 本地 `~/Desktop/高顿/` | 视频文件、讲义文档、文字稿（生成结果） |
| 项目目录 `data/高顿/` | **符号链接**，指向 `~/Desktop/高顿/`（不同电脑可指向不同路径） |
| 百度网盘 `/apps/CPA课程归档/高顿/` | 与本地完全镜像 |
| 飞书知识库「CPA备考知识库」 | 视频文字稿、文档文字、知识梳理 |
| 飞书文档 | 任务报告 |

> **符号链接说明**：项目目录中的 `data/高顿/` 是符号链接，指向外部数据目录（默认 `~/Desktop/高顿/`）。不同电脑上数据目录路径可能不同，运行 `./scripts/setup-data-symlink.sh` 可快速创建或调整符号链接。检查状态：`./scripts/setup-data-symlink.sh --check`。`data/` 目录已在 `.gitignore` 中忽略，不会提交到GitHub。

## 目录结构

本地、百度网盘、飞书知识库三者使用相同的课程/讲座层级结构。

> **详细的目录结构说明见 [docs/DIRECTORY_STRUCTURE.md](docs/DIRECTORY_STRUCTURE.md)**，包含：
> - 项目仓库目录结构（简化版 + 详细版）
> - 本地与百度网盘课程目录结构
> - 飞书知识库结构
> - Git忽略目录说明
> - 目录结构维护原则

### 项目仓库结构（摘要）

```
项目根目录/
├── docs/                 # 项目文档（方法论、指导、规范、流程、模板）
├── knowledge-base/       # 知识库内容（本地源头，同步到飞书）
├── scripts/              # 脚本（下载、压缩、转写、上传、做题等）
├── reports/              # 报告（实际报告）
├── transcription/        # 转写工作目录（.gitignore忽略）
├── .secrets/             # 加密凭证（加密文件提交到仓库）
├── data/                 # 符号链接，指向外部数据目录（.gitignore忽略）
├── README.md             # 项目介绍（本文件）
├── AGENTS.md             # AI操作手册
└── .gitignore            # 忽略规则
```

### 课程目录结构（摘要）

```
高顿/
└── CPA/
    ├── 课程库/            # 走完整流程（有知识库）
    │   └── <课程名>/
    │       └── <章节名>/
    │           ├── video.mp4
    │           ├── transcript.md
    │           ├── knowledge.md
    │           └── docs/
    └── 待整理/            # 未走完整流程（暂无知识库）
        └── <课程名>/
```

### 飞书知识库结构（摘要）

知识库名称：**CPA备考知识库**，结构与本地/网盘一致。

---
## 系统要求

> ⚠️ **项目主要在 macOS 下开发和运行**，部分工具依赖 macOS 原生功能。如需在其他平台运行，需替换对应工具。

### 支持的平台

| 平台 | 支持状态 | 说明 |
|------|---------|------|
| **macOS 12+** | ✅ 完全支持 | 主要开发和运行环境 |
| Linux | ⚠️ 部分支持 | 需替换 OCR 方案，终端工具不同 |
| Windows | ⚠️ 部分支持 | 需替换 OCR 方案，bash 脚本需 WSL |

### Mac 专用工具（不可直接跨平台）

| 工具 | 用途 | 替代方案（其他平台） |
|------|------|---------------------|
| **macOS Vision 框架** | PDF/图片 OCR 文字提取 | Tesseract OCR / PaddleOCR |
| **iTerm2** | 批量任务前台运行（实时进度） | GNOME Terminal / Windows Terminal |
| **textutil** | DOC/DOCX 文字提取 | python-docx / pandoc |
| **AppleScript** | iTerm 窗口控制 | 无直接替代 |
| **bash 3.2** | 脚本运行环境（Mac自带） | 升级到 bash 4+ 或调整脚本 |

### 跨平台工具（可直接使用）

| 工具 | 用途 |
|------|------|
| ffmpeg | 视频下载、解密、压缩、验证 |
| Playwright CLI | 浏览器自动化 |
| Node.js | HLS 分片下载脚本 |
| Python 3.10+ | 转写、OCR批处理、网盘上传 |
| FunASR / faster-whisper | 音频转文字 |
| 百度网盘 PCS API | 文件上传 |

### 硬件要求

- **CPU**：建议 8 核以上（视频压缩和音频转写耗时较长）
- **内存**：建议 16GB 以上（转写模型加载需要）
- **磁盘**：建议 500GB 以上（原始视频 + 压缩视频 + 转写中间文件）
- **网络**：稳定的互联网连接（视频下载、网盘上传、飞书API）

### 开发与测试环境（当前配置）

> 项目目前主要在以下 Mac 环境下开发和测试，其他环境可能存在兼容性问题。

**系统信息**：
- **操作系统**：macOS 15.7.8 (Sequoia)
- **BuildVersion**：24G824
- **Shell**：bash 3.2.57(1)-release（Mac自带版本）

**硬件配置**：
- **机型**：Mac Pro
- **CPU**：13th Intel Core i5-13600KF @ 3.5 GHz（14核20线程）
- **内存**：128 GB
- **磁盘**：3.7TB NVMe（可用3.1TB）

**已安装工具与版本**：

| 工具 | 版本 | 安装方式 |
|------|------|---------|
| ffmpeg | 8.1.2 | Homebrew |
| Node.js | v20.20.2 | Homebrew |
| npm | 10.8.2 | 随Node.js |
| Python | 3.13.13 | Homebrew |
| pip | 26.1.1 | 随Python |
| git | 2.45.2 | Xcode Command Line Tools |
| Homebrew | 6.0.19 | 官方安装脚本 |
| Google Chrome | 最新版 | 官方下载 |
| iTerm2 | 最新版 | 官方下载 |

**Mac 特定设置**：
- **OCR**：使用 macOS Vision 框架（系统原生，无需额外安装）
- **终端**：批量任务必须在 iTerm2 前台运行，禁止后台运行
- **安全设置**：允许 Apple 事件中的 JavaScript（iTerm 控制需要）
- **Playwright**：使用 Extension 模式附加已运行的 Chrome，不使用 CDP 模式

**注意事项**：
- 项目在 Intel Mac 上测试通过，Apple Silicon (M1/M2/M3) 可能需要额外配置（如 FunASR 环境）
- macOS 版本低于 12 可能不支持部分 Vision 框架功能
- bash 脚本基于 bash 3.2 编写，在 bash 4+ 上可能需要调整

### 迁移到新 Mac 的步骤

1. 克隆仓库：`git clone <repo-url>`
2. 安装依赖：`brew install ffmpeg node python@3.11`
3. 搭建转写环境：`bash scripts/setup-transcription-env.sh`
4. 配置数据目录：`bash scripts/setup-data-symlink.sh`
5. 解密凭证：`bash scripts/secrets.sh decrypt baidu_credentials`
6. 验证：运行 `bash scripts/check_directory_structure.sh`

## 技术方案

- 浏览器自动化：Playwright Extension 模式附加 Chrome
- 密钥提取：Hook hls.js Worker 通信截获 AES-128 密钥
- 下载：Node.js 多线程下载 HLS 分片
- 解密：AES-128-CBC
- 压缩：ffmpeg H.265 CRF30 + AAC 96k
- 网盘：百度网盘 PCS API 分片上传（4MB 分片，MD5 秒传）
- 验证：ffprobe 自动校验时长和可播放性

## 密钥管理

敏感凭证使用 openssl AES-256-CBC -pbkdf2 加密存储，加密文件提交到仓库，解密密码由用户保管。

```bash
./scripts/secrets.sh decrypt <name>   # 解密查看
```

## 项目维护规则

> ⚠️ **执行任何任务前，必须先读 [AGENTS.md](AGENTS.md)** — 里面有全局执行规则、文档快速入口、存储分工等核心要求。
>
> 每次开始新任务前、完成大任务后，必须检查项目结构是否合理，发现问题主动梳理调整。
> 详细规范见 [docs/project-management/standards/PROJECT_MAINTENANCE.md](docs/project-management/standards/PROJECT_MAINTENANCE.md)

### 核心原则

1. **GitHub 仓库只放代码和文档**：生成结果（视频、PDF、文字稿）放本地和百度网盘
2. **脚本统一放 `scripts/`**：不分散在各子目录
3. **文档按专业领域分类**：`docs/project-management/`、`docs/development/`
4. **具体产出物放对应课程目录**：验证报告、知识梳理等和被验证对象在一起
5. **定期清理**：测试文件、临时日志、残留目录及时清理

### 文档组织三层保障

| 层级 | 位置 | 内容 |
|------|------|------|
| 第一层 | **README.md 正文** | 核心规则、维护原则、存储分工 |
| 第二层 | **docs/ 子文档** | 详细操作步骤、参数、常见问题 |
| 第三层 | **自动化机制** | pre-commit hook、脚本检查 |

### 问题驱动更新（强制）

发现任何问题（文件位置不对、脚本有bug、流程有缺陷等）时，必须立即评估是否需要更新文档或自动化检查，评估后必须执行，不能只发现问题不更新。

## 完整工作流

详见 [docs/WORKFLOW.md](docs/WORKFLOW.md)（持续更新）。

简要流程：建目录 → 下载视频 → 下载文档 → 压缩验证 → 同步网盘 → 内容解析 → 知识库 → 做题验证 → 任务报告

## 文档快速入口

按任务类型查找文档（执行前必读对应文档）：

| 任务类型 | 先看 | 再看 |
|----------|------|------|
| **全局规则** | [AGENTS.md](AGENTS.md) | - |
| 视频下载/压缩 | [WORKFLOW.md 第2节](docs/WORKFLOW.md) | [video-processing.md](docs/development/tools/video-processing.md) |
| 文档下载 | [WORKFLOW.md 第3节](docs/WORKFLOW.md) | - |
| 百度网盘同步 | [WORKFLOW.md 第4节](docs/WORKFLOW.md) | [netdisk-setup.md](docs/development/api/netdisk-setup.md) |
| 视频转文字 | [WORKFLOW.md 第5节](docs/WORKFLOW.md) | [transcription.md](docs/development/tools/transcription.md) |
| 知识库生成 | [WORKFLOW.md 第6节](docs/WORKFLOW.md) | [knowledge-base-organization.md](docs/development/knowledge/knowledge-base-organization.md) |
| **做题验证** | [WORKFLOW.md 第7节](docs/WORKFLOW.md) | ⚠️ [exam-workflow.md](docs/development/guides/exam-workflow.md) |
| 任务报告 | [WORKFLOW.md 第8节](docs/WORKFLOW.md) | [project-management/README.md](docs/project-management/README.md) |
| Git操作 | [git-workflow.md](docs/development/guides/git-workflow.md) | - |
| 项目维护 | [PROJECT_MAINTENANCE.md](docs/project-management/standards/PROJECT_MAINTENANCE.md) | - |
| OCR识别 | [ocr.md](docs/development/tools/ocr.md) | - |
| 飞书API | [feishu-api.md](docs/development/api/feishu-api.md) | - |

## 文档同步清单

每次完成阶段性任务后，按清单检查并同步相关文档。详见 [docs/project-management/DOC_SYNC_CHECKLIST.md](docs/project-management/DOC_SYNC_CHECKLIST.md)。

清单包含：
- 任务管理类（任务状态、测试计划、课程索引）
- 做题产出类（做题记录、用户笔记、验证报告）
- 知识库内容类（知识拆解、考试指导、通用方法）
- 方法论类（做题方法论、知识库组织方法论）
- 工作流与项目计划
- 开发文档类
- 项目概览类（README）
