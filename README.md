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
| 本地 `~/Desktop/高顿/` | 视频文件、讲义文档、文字稿 |
| 百度网盘 `/apps/CPA课程归档/高顿/` | 与本地完全镜像 |
| 飞书知识库「CPA备考知识库」 | 视频文字稿、文档文字、知识梳理 |
| 飞书文档 | 任务报告 |

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
├── video.mp4          # 压缩后的最终视频
├── transcript.md      # 视频文字稿（语音转文字 + 画面 OCR）
├── docs/              # 讲义文档原件（PDF/PPT/DOC）
└── docs_text/         # 文档提取的文字
```

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
├── skill/                    # 全局 Skill 副本
│   ├── SKILL.md
│   ├── scripts/              # capture_key.js, download_decrypt.js, compress.sh
│   └── references/           # encryption.md, baidupan.md
├── scripts/
│   ├── baidu_upload.py       # 百度网盘分片上传
│   └── secrets.sh            # 密钥加密/解密工具
├── docs/
│   ├── PROJECT_PLAN.md       # 项目计划
│   ├── WORKFLOW.md           # 完整工作流（持续更新）
│   ├── COURSE_INDEX.md       # 课程清单索引
│   └── BAIDU_NETDISK_SETUP.md # 百度网盘接入文档
├── reports/
│   └── REPORT_TEMPLATE.md    # 任务报告模板
└── .secrets/                 # 加密凭证（已提交，密码由用户保管）
    ├── gh_token.enc
    └── baidu_credentials.enc
```

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

## 完整工作流

详见 [docs/WORKFLOW.md](docs/WORKFLOW.md)（持续更新）。

简要流程：建目录 → 下载视频 → 下载文档 → 压缩验证 → 同步网盘 → 内容解析 → 知识库 → 做题验证 → 任务报告
