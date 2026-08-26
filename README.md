# 高顿 CPA 课程知识库项目

自动化下载高顿 Glive 平台 CPA 课程回放视频（HLS AES-128 加密），解密合并压缩后归档，并构建飞书知识库。

## 仓库地址

- GitHub: https://github.com/byte886/cpa-course-archive （私有）

## 课程

- 【26考季】VIPCPA系列-税法（蔡俊峻老师）— 39场直播（跳过开班典礼后38场）
- 【26考季】VIPCPA系列-会计（罗翔老师）— 待采集

## 存储分工

| 位置 | 内容 |
|------|------|
| GitHub 仓库 | Skill 代码、需求文档、项目计划、报告模板、密钥管理脚本 |
| 百度网盘 | 视频文件、讲义文档、文字稿 |
| 飞书 | 任务报告、知识库 |

## 技术方案

- 浏览器自动化：Playwright Extension 模式附加 Chrome
- 密钥提取：Hook hls.js Worker 通信截获 AES-128 密钥
- 下载：Node.js 多线程下载 HLS 分片
- 解密：AES-128-CBC（密钥为 Worker 解密响应前16字节 ASCII）
- 压缩：ffmpeg H.265 CRF30 + AAC 96k
- 验证：ffprobe 自动校验时长和可播放性

## 目录结构

```
gaodun_downloads/
├── skill/                    # 全局 Skill 副本（同步到 GitHub）
│   ├── SKILL.md
│   ├── scripts/              # capture_key.js, download_decrypt.js, compress.sh
│   └── references/           # encryption.md, baidupan.md
├── scripts/
│   └── secrets.sh            # 密钥加密/解密工具
├── docs/
│   ├── PROJECT_PLAN.md       # 项目计划
│   ├── COURSE_INDEX.md       # 课程清单索引
│   └── manifest.json         # 下载清单（含完成状态）
├── reports/
│   └── REPORT_TEMPLATE.md    # 任务报告模板
├── .secrets/                 # 加密凭证（.gitignore，不提交）
│   └── gh_token.enc          # GitHub Token (AES-256-CBC 加密)
├── 税法-蔡俊峻/               # 课程文件（同步到百度网盘）
│   └── 01_税法全面精讲01-税法总论/
│       ├── video.mp4
│       ├── transcript.md     # 视频文字稿
│       └── docs/
└── 会计-罗翔/
```

## 密钥管理

敏感凭证（GitHub Token、百度网盘 OAuth Token 等）使用 openssl AES-256-CBC 加密存储：

```bash
# 加密保存 token
./scripts/secrets.sh encrypt <token>

# 解密查看
./scripts/secrets.sh decrypt

# 解密并登录 gh
./scripts/secrets.sh gh-auth
```

- 加密算法：`openssl enc -aes-256-cbc -salt -pbkdf2`
- 加密文件存于 `.secrets/` 目录，已加入 `.gitignore`，不会提交到 GitHub
- 解密密码由用户保管，AI 不记录密码；需要解密时向用户询问

## 完整工作流

详见 [docs/WORKFLOW.md](docs/WORKFLOW.md)（持续更新）。

简要流程：建目录 → 下载视频 → 下载文档 → 同步网盘 → 内容解析 → 知识库 → 做题验证 → 任务报告

## 压缩参数

- 编码器：libx265 (H.265/HEVC)
- CRF：30（课件文字清晰，头像略糊但不影响学习）
- Preset：fast
- 音频：AAC 96kbps
