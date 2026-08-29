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

### 本地与百度网盘（完全镜像）

```
高顿/                                    ← 本地: ~/Desktop/高顿/
└── CPA/                                 ← 网盘: /apps/CPA课程归档/高顿/CPA/
    ├── 课程库/                          ← 走完整流程（有知识库）
    │   ├── 【26考季】VIPCPA系列-税法（蔡俊峻老师）/
    │   │   ├── 01_税法全面精讲01-税法总论/
    │   │   │   ├── video.mp4
    │   │   │   ├── transcript.md
    │   │   │   ├── docs/
    │   │   │   └── docs_text/
    │   │   └── ...
    │   └── 【26考季】VIPCPA系列-会计（罗翔老师）/
    └── 待整理/                          ← 未走完整流程（暂无知识库）
        └── 【26考季】VIPCPA-基础必修-会计（罗翔老师）/
            ├── 01_会计总论(一)/
            └── ...
```

每个讲座目录下：
```
NN_讲座标题/
├── video.mp4          # 压缩后的最终视频（H.265 CRF30）
├── transcript.md      # 视频文字稿（语音转文字）
├── transcript.json    # 转写原始数据（含时间戳）
├── knowledge.md       # 知识梳理（转写+讲义合并，生成知识库用）
├── docs/              # 讲义文档原件（PDF/PPT/DOC）
├── VERIFICATION_knowledge.md  # 知识梳理文档验证报告
└── .uploaded          # 上传标记（已上传到百度网盘后生成）
```

> **说明**：
> - `docs_text/` 目录已取消，文档提取的文字直接合并到 `knowledge.md`
> - `.uploaded` 是上传标记文件，存在表示已上传到百度网盘
> - 课程根目录下可能有 `upload_log.txt`（上传日志）和 `.DS_Store`（macOS系统文件，应忽略）

### 飞书知识库

知识库名称：**CPA备考知识库**

结构与本地/网盘一致，每个讲座对应一个知识库页面：

```
CPA备考知识库/
└── CPA/
    ├── 课程库/
    │   ├── 【26考季】VIPCPA系列-税法（蔡俊峻老师）/
    │   │   ├── 01_税法全面精讲01-税法总论    ← 页面：视频文字稿 + 讲义要点
    │   │   └── ...
    │   └── 【26考季】VIPCPA系列-会计（罗翔老师）/
    └── 待整理/
        └── 【26考季】VIPCPA-基础必修-会计（罗翔老师）/
```

"待整理"中的课程走完知识库流程后，移动到"课程库"下（本地、网盘、知识库三处同步移动）。

### GitHub 仓库

```
cpa-course-archive/
├── .gitignore                # Git忽略规则（视频/文档/音频/转写结果等）
├── README.md                 # 项目说明（本文档）
├── AGENTS.md                 # 全局执行规则、文档快速入口、存储分工
├── .secrets/                 # 加密凭证（已提交，密码由用户保管）
│   ├── gh_token.enc          # GitHub Personal Access Token（加密）
│   └── baidu_credentials.enc # 百度网盘API凭证（加密）
├── scripts/                  # 所有可执行脚本（视频下载/压缩/转写/上传等）
│   ├── capture_key.js        # HLS AES密钥捕获（Playwright Worker hook注入）
│   ├── download_decrypt.js   # HLS分片下载并AES-128解密合并
│   ├── compress.sh           # ffmpeg压缩为H.265 MP4（CRF30，iTerm显示进度）
│   ├── baidu_upload.py       # 百度网盘分片上传（4MB分片+MD5秒传）
│   ├── batch_upload.sh       # 批量上传视频（iTerm运行，断点续传）
│   ├── upload_course.sh      # 课程目录批量上传（自动过滤技术过程文档）
│   ├── transcribe_pipeline.py # 音频转文字（FunASR+VAD）
│   ├── batch_transcribe.sh   # 批量转写（iTerm运行，断点续传）
│   ├── batch_ocr.sh          # 批量OCR（macOS Vision框架）
│   ├── playwright_connect.sh # Playwright连接脚本（自动处理连接确认）
│   ├── secrets.sh            # 密钥加密/解密工具（AES-256-CBC）
│   ├── setup-data-symlink.sh # data/符号链接设置（跨电脑调整路径）
│   ├── setup-transcription-env.sh # 转写环境搭建（新电脑一键创建虚拟环境）
│   ├── pre-commit            # pre-commit hook源文件（大文件/敏感信息检查）
│   └── README.md             # 脚本说明文档（用途/用法/依赖/相关文档）
├── docs/
│   ├── WORKFLOW.md           # 总体工作流（索引+流程）
│   ├── project-management/   # 项目管理
│   │   ├── README.md         # 项目管理规范（任务管理/测试驱动/缺陷管理）
│   │   ├── DOC_SYNC_CHECKLIST.md # 文档同步清单
│   │   ├── active/           # 活跃文档
│   │   │   ├── TASK_STATUS.md    # 任务状态（唯一任务状态来源）
│   │   │   └── COURSE_INDEX.md   # 课程清单索引
│   │   ├── standards/        # 标准规范
│   │   │   ├── PROJECT_PLAN.md   # 项目计划
│   │   │   ├── QUALITY_ASSURANCE.md # 质量保证规范
│   │   │   └── PROJECT_MAINTENANCE.md # 项目维护规则
│   │   └── test-plans/       # 测试计划
│   │       └── TEST_PLAN_税法01.md # 税法01测试计划
│   ├── development/          # 开发文档
│   │   ├── README.md         # 开发文档索引
│   │   ├── git-workflow.md   # Git工作流（SSH/代理/大文件/pre-commit/敏感信息）
│   │   ├── playwright-cli-guide.md # Playwright CLI使用指南（正确用法/常见错误/最佳实践）
│   │   ├── video-processing.md # 视频处理详细指南（下载/解密/压缩/验证/加密逆向分析）
│   │   ├── encryption.md     # HLS AES-128加密逆向分析（密钥提取/解密参数/验证方法）
│   │   ├── transcription.md  # 音频转文字（FunASR环境/参数/性能）
│   │   ├── ocr.md            # OCR文字提取（macOS Vision/表格图表AI补充）
│   │   ├── netdisk-setup.md # 百度网盘接入（应用创建/API配置/上传脚本）
│   │   ├── feishu-api.md     # 飞书API使用（知识库/文档/表格/权限设置）
│   │   ├── knowledge-base-organization.md # 知识库结构设计/节点命名规范/父页面规范
│   │   ├── knowledge-base-sources.md # 知识库来源清单/来源选择流程/同步流程
│   │   ├── exam-workflow.md  # 做题工作流（页面管理/补题流程/答题卡操作/踩坑记录）
│   │   └── interaction-workflow.md # 通用交互流程与优化规范（适用于做题/模考等所有Web交互）
│   └── knowledge-base/       # 知识库内容（本地）
│       ├── KNOWLEDGE_BASE_TEMPLATE.md # 知识库页面模板
│       ├── methodology/      # 方法论文档
│       │   ├── 做题流程与方法论.md # 做题完整流程/API探索/经验总结
│       │   └── 交互优化指南.md     # 做题页面交互规律/问题/优化方案
│       ├── organized-content/ # 整理后的知识内容
│       │   ├── 做题思路解析.md     # 面向学习者的通用做题思路
│       │   └── 01税法总论/         # 章节知识
│       │       ├── README.md        # 章节概览（含子节点链接）
│       │       ├── 知识拆解.md      # 章节核心知识点
│       │       ├── 考试指导.md      # 做题技巧/易错点/记忆口诀
│       │       ├── VERIFICATION_税法总论_分章真题测.md # 知识库质量验证报告
│       │       └── SYNC_REPORT_税法总论_20260828.md # 飞书知识库同步报告
│       └── source-materials/ # 原始素材
│           └── 税法总论/
│               ├── 做题记录_*.md    # 各试卷做题记录
│               ├── 解析与用户留言_*.md # 官方解析和用户留言整理
│               └── 用户笔记精华_税法总论.md # 高赞用户留言整理
├── transcription/            # 转写工作目录
│   ├── requirements.txt      # Python依赖清单（64个包，新电脑复现环境用）
│   ├── venv/                 # Python虚拟环境（gitignore忽略，不提交）
│   └── transcripts_full/     # 转写结果输出（gitignore忽略，不提交）
│       └── video/            # 视频转写结果（transcript.md/transcript.json）
├── data/                     # 符号链接目录（gitignore忽略，不提交）
│   └── 高顿/                 # 符号链接 → ~/Desktop/高顿/（不同电脑可指向不同路径）
└── .git/hooks/
    └── pre-commit            # 实际生效的pre-commit hook（从scripts/pre-commit复制）
```

> **Git忽略目录说明**：
> | 目录 | 忽略原因 | 复现方式 |
> |------|----------|----------|
> | `transcription/venv/` | Python虚拟环境，路径硬编码，不应复制 | `./scripts/setup-transcription-env.sh` 重新创建 |
> | `transcription/transcripts_full/` | 转写结果，生成文件，放本地和网盘 | 重新运行转写脚本生成 |
> | `data/` | 符号链接指向外部大文件目录（视频/文档） | `./scripts/setup-data-symlink.sh` 创建链接 |
> 
> **虚拟环境迁移原则**：Python虚拟环境不直接复制到新电脑，用 `requirements.txt` + 搭建脚本重新创建。

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
| **做题验证** | [WORKFLOW.md 第7节](docs/WORKFLOW.md) | ⚠️ [exam-workflow.md](docs/development/workflow/exam-workflow.md) |
| 任务报告 | [WORKFLOW.md 第8节](docs/WORKFLOW.md) | [project-management/README.md](docs/project-management/README.md) |
| Git操作 | [git-workflow.md](docs/development/workflow/git-workflow.md) | - |
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
