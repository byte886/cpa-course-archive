# 目录结构详细说明

> **文档类型**：Reference（参考资料）
> **更新频率**：目录结构变更时
> **维护者**：AI自动维护
> **读者**：AI代理+人类

本文档详细说明项目的各类目录结构，包括项目仓库结构、本地与网盘课程目录结构、飞书知识库结构。

> README.md 中只保留摘要和链接，详细内容见本文档。

---

## 一、项目仓库目录结构（GitHub）

### 1.1 简化版

```
项目根目录/
├── docs/                          # 项目文档（方法论、指导、规范、流程、模板）
│   ├── development/               # 开发文档
│   │   ├── api/                   # API文档（飞书API、百度网盘API）
│   │   ├── guides/                # 详细操作指南（做题、Git、交互）
│   │   ├── knowledge/             # 知识库方法论（组织规范、来源清单）
│   │   ├── templates/             # 模板（知识库模板、父节点模板）
│   │   └── tools/                 # 工具使用文档（视频处理、转写、OCR、Playwright）
│   ├── project-management/        # 项目管理
│   │   ├── active/                # 活动状态（任务状态、问题跟踪、课程索引）
│   │   ├── decisions/             # 决策记录（ADR）
│   │   ├── standards/             # 规范文档（命名规范、文档同步、项目维护等）
│   │   └── test-plans/            # 测试计划
│   ├── WORKFLOW.md                # 主工作流（总体流程概览）
│   ├── REQUIREMENTS.md            # 需求文档
│   └── DOCUMENTATION_MAP.md       # 文档地图（所有文档索引）
├── knowledge-base/                # 知识库内容（本地源头，同步到飞书）
│   ├── organized-content/         # 整理后的知识内容（成品）
│   │   ├── 通用方法/              # 面向所有课程的通用方法论
│   │   ├── 01税法总论/            # 各章节知识（知识拆解、考试指导、验证报告）
│   │   └── ...
│   └── source-materials/          # 原始素材（原材料，用于生成知识库）
│       ├── 税法-总论/             # 各课程的做题记录、解析、用户笔记
│       └── ...
├── scripts/                       # 脚本（下载、压缩、转写、上传、做题等）
├── reports/                       # 报告（实际报告，模板已移到 docs/development/templates/）
├── transcription/                 # 转写工作目录（.gitignore忽略）
├── .secrets/                      # 加密凭证（加密文件提交到仓库）
├── .github/                       # GitHub模板（PR模板、Issue模板）
├── data/                          # 符号链接，指向外部数据目录（.gitignore忽略）
├── README.md                      # 项目介绍
├── AGENTS.md                      # AI操作手册（每次启动自动加载）
├── CHANGELOG.md                   # 变更日志
├── CONTRIBUTING.md                # 贡献指南
├── LICENSE                        # MIT协议
└── .gitignore                     # 忽略规则
```

### 1.2 详细版（含文件说明）

```
cpa-course-archive/
├── .gitignore                # Git忽略规则（视频/文档/音频/转写结果等）
├── README.md                 # 项目说明
├── AGENTS.md                 # 全局执行规则、文档快速入口、存储分工
├── .secrets/                 # 加密凭证（已提交，密码由用户保管）
│   ├── gh_token.enc          # GitHub Personal Access Token（加密）
│   └── baidu_credentials.enc # 百度网盘API凭证（加密）
├── scripts/                  # 所有可执行脚本
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
│   ├── answer_option.sh      # 单选题答题脚本
│   ├── answer_multi.sh       # 多选题答题脚本
│   ├── submit_exam.sh        # 交卷脚本
│   ├── check_directory_structure.sh # 检查目录结构
│   ├── check-kb-structure.sh # 检查知识库结构
│   ├── collect_analysis.js   # 收集解析
│   ├── pre-commit            # pre-commit hook源文件（大文件/敏感信息检查）
│   └── README.md             # 脚本说明文档
├── docs/
│   ├── WORKFLOW.md           # 总体工作流（索引+流程）
│   ├── REQUIREMENTS.md       # 需求文档
│   ├── DOCUMENTATION_MAP.md  # 文档地图
│   ├── DIRECTORY_STRUCTURE.md # 目录结构详细说明（本文档）
│   ├── project-management/   # 项目管理
│   │   ├── README.md         # 项目管理规范
│   │   ├── DOC_SYNC_CHECKLIST.md # 文档同步清单
│   │   ├── active/           # 活跃文档
│   │   │   ├── TASK_STATUS.md    # 任务状态（唯一任务状态来源）
│   │   │   ├── ISSUES.md         # 问题跟踪
│   │   │   └── COURSE_INDEX.md   # 课程清单索引
│   │   ├── standards/        # 标准规范
│   │   │   ├── PROJECT_PLAN.md   # 项目计划
│   │   │   ├── QUALITY_ASSURANCE.md # 质量保证规范
│   │   │   ├── PROJECT_MAINTENANCE.md # 项目维护规则
│   │   │   ├── NAMING_CONVENTION.md # 命名规范
│   │   │   ├── BATCH_TASK_EXECUTION.md # 大任务执行规范
│   │   │   └── PROJECT_STATUS_QUERY.md # 状态查询协议
│   │   ├── decisions/        # 决策记录（ADR）
│   │   └── test-plans/       # 测试计划
│   └── development/          # 开发文档
│       ├── README.md         # 开发文档索引
│       ├── api/              # API文档
│       │   ├── feishu-api.md     # 飞书API使用
│       │   ├── netdisk-setup.md  # 百度网盘接入
│       │   └── encryption.md      # 加密凭证
│       ├── guides/           # 详细操作指南
│       │   ├── exam-workflow.md      # 做题工作流
│       │   ├── git-workflow.md       # Git工作流
│       │   └── interaction-workflow.md # 通用交互流程
│       ├── knowledge/        # 知识库方法论
│       │   ├── knowledge-base-organization.md # 知识库组织规范
│       │   └── knowledge-base-sources.md      # 知识库来源清单
│       ├── tools/            # 工具使用文档
│       │   ├── playwright-cli-guide.md # Playwright CLI使用指南
│       │   ├── video-processing.md    # 视频处理详细指南
│       │   ├── transcription.md       # 音频转文字
│       │   ├── ocr.md                 # OCR文字提取
│       │   └── document-download.md   # 文档下载
│       └── templates/        # 模板文件
│           ├── KNOWLEDGE_BASE_TEMPLATE.md # 知识库页面模板
│           ├── PARENT_NODE_TEMPLATE.md    # 父节点页面模板
│           ├── REPORT_TEMPLATE.md          # 任务报告模板
│           ├── VERIFICATION_TEMPLATE.md    # 通用验证报告模板
│           └── VERIFICATION_TEMPLATE_knowledge_base.md # 知识库验证报告模板
├── knowledge-base/           # 知识库实际内容（本地）
│   ├── organized-content/    # 整理后的知识内容
│   │   ├── 通用方法/         # 面向所有课程的通用方法论
│   │   └── 01税法总论/      # 章节知识
│   │       ├── README.md        # 章节概览（含子节点链接）
│   │       ├── 知识拆解.md      # 章节核心知识点
│   │       ├── 考试指导.md      # 做题技巧/易错点/记忆口诀
│   │       ├── VERIFICATION_*.md # 知识库质量验证报告
│   │       └── SYNC_REPORT_*.md  # 飞书知识库同步报告
│   └── source-materials/     # 原始素材
│       └── 税法-总论/
│           ├── 做题记录_*.md    # 各试卷做题记录
│           ├── 解析与用户留言_*.md # 官方解析和用户留言整理
│           └── 用户笔记精华_*.md # 高赞用户留言整理
├── transcription/            # 转写工作目录
│   ├── requirements.txt      # Python依赖清单（新电脑复现环境用）
│   ├── venv/                 # Python虚拟环境（gitignore忽略，不提交）
│   └── transcripts_full/     # 转写结果输出（gitignore忽略，不提交）
├── reports/                  # 报告（实际报告）
│   ├── README.md             # 报告目录说明
│   └── REPORT_00_开班典礼.md # 实际报告
├── data/                     # 符号链接目录（gitignore忽略，不提交）
│   └── 高顿/                 # 符号链接 → ~/Desktop/高顿/
└── .git/hooks/
    └── pre-commit            # 实际生效的pre-commit hook
```

### 1.3 Git忽略目录说明

| 目录 | 忽略原因 | 复现方式 |
|------|----------|----------|
| `transcription/venv/` | Python虚拟环境，路径硬编码，不应复制 | `./scripts/setup-transcription-env.sh` 重新创建 |
| `transcription/transcripts_full/` | 转写结果，生成文件，放本地和网盘 | 重新运行转写脚本生成 |
| `data/` | 符号链接指向外部大文件目录（视频/文档） | `./scripts/setup-data-symlink.sh` 创建链接 |

**虚拟环境迁移原则**：Python虚拟环境不直接复制到新电脑，用 `requirements.txt` + 搭建脚本重新创建。

---

## 二、本地与百度网盘（完全镜像）

本地、百度网盘、飞书知识库三者使用相同的课程/讲座层级结构。

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

### 每个讲座目录下

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

---

## 三、飞书知识库

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

---

## 四、目录结构维护原则

1. **本地、网盘、知识库三者结构一致**：课程/讲座层级结构在三处保持同步
2. **项目仓库只放代码和文档**：生成结果（视频、PDF、文字稿）放本地和网盘，不放GitHub
3. **模板统一管理**：所有模板放在 `docs/development/templates/`，其他目录不放模板
4. **目录结构变更时同步更新**：新增/移动/删除目录时，必须更新本文档和 README.md
5. **文件和目录有变化时检查 .gitignore**：确保新的文件类型或目录被正确忽略
