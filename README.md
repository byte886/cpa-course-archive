# 高顿 CPA 课程智能归档项目

把在线课程变成你自己的、可搜索、可问答、永久保存的备考资产。

最终你会得到：

1. **一个永不失效的课程资料库** — 所有购买的 CPA 课程视频和讲义保存在本地和百度网盘，平台到期也能看
2. **一个可搜索的个人知识库** — 视频里老师讲的、讲义上写的，全部变成文字，按课程章节组织在飞书知识库里，随时搜得到
3. **一个会做题的备考助手** — 学完直接做课后练习，知识库帮你找答案、对依据、查漏补缺

## 仓库地址

- GitHub: https://github.com/byte886/cpa-course-archive （公有）

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
├── .secrets/                 # 加密凭证（已提交，密码由用户保管）
│   ├── gh_token.enc          # GitHub Personal Access Token（加密）
│   └── baidu_credentials.enc # 百度网盘API凭证（加密）
├── skill/                    # 全局 Skill 副本（gaodun-course-downloader）
│   ├── SKILL.md              # Skill说明文档
│   ├── scripts/              # Skill脚本
│   │   ├── capture_key.js    # HLS密钥截获
│   │   ├── download_decrypt.js # HLS下载解密
│   │   └── compress.sh       # ffmpeg压缩脚本
│   └── references/           # Skill参考文档
│       ├── encryption.md     # 加密说明
│       └── baidupan.md      # 百度网盘API说明
├── scripts/                  # 所有脚本统一放这里
│   ├── baidu_upload.py       # 百度网盘分片上传
│   ├── batch_upload.sh       # 批量上传
│   ├── transcribe_pipeline.py # 音频转文字（FunASR+VAD）
│   ├── batch_transcribe.sh   # 批量转写
│   ├── batch_ocr.sh          # 批量OCR（macOS Vision）
│   ├── secrets.sh            # 密钥加密/解密工具
│   ├── setup-data-symlink.sh # data/符号链接设置（跨电脑调整路径）
│   ├── setup-transcription-env.sh # 转写环境搭建（新电脑一键创建虚拟环境）
│   └── pre-commit            # pre-commit hook源文件（大文件/敏感信息检查）
├── docs/
│   ├── WORKFLOW.md           # 总体工作流（索引+流程）
│   ├── manifest.json         # 文档清单
│   ├── project-management/   # 项目管理
│   │   ├── README.md         # 项目管理规范（任务管理/测试驱动/缺陷管理）
│   │   ├── PROJECT_PLAN.md   # 项目计划
│   │   ├── COURSE_INDEX.md   # 课程清单索引
│   │   ├── TASK_STATUS.md    # 任务状态（唯一任务状态来源）
│   │   └── TEST_PLAN_*.md    # 测试计划（如TEST_PLAN_税法01.md）
│   └── development/          # 开发文档
│       ├── README.md         # 开发文档索引
│       ├── git-workflow.md   # Git工作流（SSH/代理/大文件/pre-commit/敏感信息）
│       ├── transcription.md  # 音频转文字（FunASR环境/参数/性能）
│       ├── ocr.md            # OCR文字提取（macOS Vision）
│       ├── netdisk-setup.md # 百度网盘接入（API/上传/目录管理）
│       ├── video-processing.md # 视频处理（待创建）
│       └── knowledge-base.md # 知识库建设（待创建）
├── reports/
│   └── REPORT_TEMPLATE.md    # 任务报告模板
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

> 每次开始新任务前、完成大任务后，必须检查项目结构是否合理，发现问题主动梳理调整。
> 详细规范见 [docs/project-management/PROJECT_MAINTENANCE.md](docs/project-management/PROJECT_MAINTENANCE.md)

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
