# 工作流文档

本文档记录 CPA 课程归档的完整工作流程，随实际执行持续更新。

## 总体流程

```
建目录 → 下载视频 → 下载文档 → 同步网盘 → 内容解析 → 知识库 → 做题验证 → 任务报告
```

每个讲座独立走完一遍流程，完成后再进入下一个。

---

## 1. 建目录

### 1.1 目录结构

本地根目录：`~/Desktop/高顿/`（与百度网盘 `/apps/CPA课程归档/高顿/` 完全镜像）

```
高顿/
└── CPA/                              ← 专业名（未来可扩展其他专业）
    ├── 课程库/                        ← 走完整流程的（有知识库）
    │   └── 【26考季】VIPCPA系列-税法（蔡俊峻老师）/
    │       ├── 00_开班典礼&规划方法/   ← 开班典礼（序号00）
    │       │   ├── video.mp4
    │       │   ├── transcript.md
    │       │   └── docs/
    │       └── 01_税法全面精讲01-税法总论/
    │           ├── video.mp4          # 压缩后的最终视频
    │           ├── transcript.md      # 视频文字稿（语音转文字 + 画面 OCR）
    │           ├── docs/              # 讲义文档原件
    │           │   └── *.pdf / *.pptx / *.docx
    │           └── docs_text/         # 文档提取的文字
    │               └── *.md
    └── 待整理/                        ← 未走完整流程的（暂无知识库）
        └── 【26考季】VIPCPA-基础必修-会计（罗翔老师）/
            └── 01_会计总论(一)/
                └── video.mp4
```

目录名规则：
- 公司目录：`高顿`
- 专业目录：`CPA`（未来可加其他专业）
- 课程目录：使用高顿学习空间中的完整课程名，如 `【26考季】VIPCPA系列-税法（蔡俊峻老师）`
- 讲座目录：`01_税法全面精讲01-税法总论`（两位序号 + 标题）
- **包含开班典礼**：`00_开班典礼&规划方法`（序号00，作为课程的第一讲处理）
- "待整理"中的课程走完知识库流程后，移动到"课程库"下

### 1.2 本地与网盘同步原则

- 所有文件先放入本地目录，再上传到网盘
- 本地和网盘目录结构始终保持一致
- 上传完成后在网盘验证文件大小

---

## 2. 下载视频

### 2.1 捕获密钥和 m3u8

1. Playwright Extension 模式附加 Chrome（会话名 `ga`）
2. 打开课程表页，点击目标讲座的"看回放"
3. 注入 Worker hook 脚本（`skill/scripts/capture_key.js`）
4. reload 播放器页面，等待视频开始加载
5. 切换到 1080P 分辨率（右下角按钮）
6. 从 hook 截获的通信中提取：
   - FHD m3u8 URL（含 token，会过期）
   - AES 密钥（Worker decrypt 响应前 16 字节的 ASCII 字符串）
   - IV（m3u8 中的 `IV=0x...`）

### 2.2 下载解密合并

```bash
node skill/scripts/download_decrypt.js <m3u8_url> <key> <iv> <输出目录>
```

- 多线程下载 .ts 分片，支持断点续传
- AES-128-CBC 解密，`setAutoPadding(false)`
- 合并为 `merged.ts`
- **验证**：检查每个分片解密后首字节为 0x47（TS sync byte）

### 2.3 压缩

在 **iTerm2 单窗口**中运行，用户可直接看 ffmpeg 实时进度：

```bash
ffmpeg -i merged.ts \
  -c:v libx265 -crf 30 -preset fast \
  -x265-params "pools=N:frame-threads=4:wpp=1" \
  -c:a aac -b:a 96k \
  -tag:v hvc1 -movflags +faststart \
  video.mp4
```

参数说明：
- `-crf 30`：恒定质量因子，数值越大体积越小质量越低；30 经测试课件文字清晰、头像略糊但不影响学习
- `-preset fast`：编码速度预设，fast 在速度和压缩率间平衡
- `-b:a 96k`：音频码率 96kbps，讲课语音足够
- `-tag:v hvc1`：Apple 兼容标签，确保 QuickTime/iOS 可播放
- `-movflags +faststart`：moov atom 前置，支持流式播放

### 2.4 验证（必须执行）

```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 video.mp4
```

- 时长与原始 merged.ts 一致（误差 < 1 秒）
- moov atom 存在（faststart 生效）
- 用播放器实际播放检查开头无黑屏

---

## 3. 下载文档

### 3.1 获取下载链接

课程表页每个直播场次下展开"讲义"/"课件"条目：
- 点击"下载"按钮会触发 fetch 到 CDN 直链
- CDN 域名：`simg01.gaodunwangxiao.com/newoss/resources/...`
- PDF 可直接 curl 下载，无需认证

```bash
curl -L -o docs/课件.pdf -e "https://glivepro.gaodun.com/" "<CDN直链>"
```

### 3.2 文档格式

可能是 PDF、PPT、DOC 等，以实际下载为准。下载后用 `file` 命令确认格式。

### 3.3 完整性校验

- 对照课程清单（`docs/manifest.json`）核对每个讲座应有的文档数量
- 检查文件大小是否与页面显示一致
- PDF 可用 `pdfinfo` 检查页数

---

## 4. 同步百度网盘

### 4.1 应用信息

- 应用：CPA课程归档（AppID: 124199604）
- 沙箱目录：`/apps/CPA课程归档/`（网盘客户端中为"我的应用数据/CPA课程归档/"）
- 凭证：`.secrets/baidu_credentials.enc`（AES-256-CBC 加密，密码 lover123）
- **API 直连即可**，不需要代理（Tailscale DNS Override 已修复，详见 BAIDU_NETDISK_SETUP.md）

### 4.2 上传流程

1. 解密获取 access_token：
   ```bash
   openssl enc -aes-256-cbc -d -pbkdf2 -pass pass:lover123 -base64 -in .secrets/baidu_credentials.enc
   ```
2. 按目录结构在网盘创建文件夹（mkdir API）
3. 分片上传文件（precreate → upload 4MB分片 → create）
4. 上传后 list 验证文件存在且大小正确

### 4.3 目录映射

本地目录 → 网盘路径：
```
~/Desktop/高顿/CPA/课程库/【26考季】VIPCPA系列-税法（蔡俊峻老师）/01_xxx/video.mp4
  → /apps/CPA课程归档/高顿/CPA/课程库/【26考季】VIPCPA系列-税法（蔡俊峻老师）/01_xxx/video.mp4
```

**注意**：网盘路径必须包含 `高顿/` 层，与本地目录结构完全一致。上传脚本 `scripts/batch_upload.sh` 中 `REMOTE_BASE="/apps/CPA课程归档/高顿"`。

API 参考：`skill/references/baidupan.md`，完整创建过程：`docs/BAIDU_NETDISK_SETUP.md`

---

## 5. 内容解析

### 5.1 视频转文字

**方案**：阿里 FunASR（SenseVoiceSmall），开源本地方案，0成本。

- 中文 CER 8-10%，优于 Whisper
- VAD 加速后约 15x 实时（2.5小时视频约10分钟）
- 虚拟环境：`transcription/venv/`
- 脚本：`transcription/transcribe_pipeline.py`（单视频）、`transcription/batch_transcribe.sh`（批量）
- 在 **iTerm 中运行**（可开多个窗口并行）

**详细文档**：[development/transcription.md](./development/transcription.md)

### 5.2 文档文字提取

**方案**：macOS Vision 框架 OCR（系统原生免费）。

- 高顿课件 PDF 多为图片型 PDF，需 OCR
- 工具：Swift 编译的 `/tmp/ocr_vision` + PyMuPDF（200 DPI）
- 性能：116页约2分钟
- 批量脚本：`transcription/batch_ocr.sh`（后台运行 + iTerm tail -f）
- 遇到表格/公式/图表时用 AI 视觉补充识别

**详细文档**：[development/ocr.md](./development/ocr.md)

---

## 6. 梳理到飞书知识库

### 6.1 知识库结构（初步规划）

```
CPA 备考知识库（知识空间）
├── 税法-蔡俊峻
│   ├── 01-税法总论
│   │   ├── 视频笔记
│   │   ├── 讲义要点
│   │   └── 常见考点
│   ├── 02-消费税法
│   └── ...
├── 会计-罗翔
│   └── ...
└── 任务报告
```

### 6.2 整理原则

- 按知识点而非按视频时间线组织
- 视频语音 + PPT 画面 + 讲义文档三者交叉印证
- 标注重点、考点、易错点

---

## 7. 做题验证知识库

### 7.1 总体原则

做题验证是**验证-补充闭环**，不是一次性步骤。通过做题检验知识库是否覆盖所有考点，错题和未覆盖的知识点补充回知识库。

### 7.2 执行顺序

1. **从测试的第1课开始**，按课程顺序依次完成每个讲座的课后练习
2. **所有讲座的课后练习都完成后**，再完成课程最上方的总考试（可能有多个）
3. **全部考试完成后**，根据错题情况决定如何补充相应课中的知识（如果没有必要可以不补充）

### 7.3 做题流程

每个讲座的知识库条目完成后：

1. 进入课程表页该讲座下的"课后练习"
2. **先根据知识库的内容学习**，然后再应答题目
3. 逐题作答，验证知识库是否覆盖相关知识点
4. **如果做错了**，如果系统有提示错误，可以重新做，直到完成为止
5. 记录错题和未覆盖的知识点
6. 全部完成后，将错题涉及的知识点、易错点补充回知识库的"考试指导"文档
7. 记录做题结果到任务报告

### 7.4 第一次做 vs 重新做

- **第一次做**：按上述流程完整执行
- **重新做**：即使之前做过，也要重新做一遍，确保知识库更新后仍然能覆盖所有考点
- 已完成的试卷显示"重新做题"按钮，未完成的试卷直接点击进入

### 7.5 错题补充原则

- 错题涉及的知识点如果知识库中没有，补充到"知识本身"文档
- 错题涉及的易错点、陷阱、解题技巧，补充到"考试指导"文档
- 如果错题是因为知识库表述不准确，修正知识库内容
- 补充后记录到任务报告

---

## 8. 任务报告

每次批量任务完成后生成报告，记录到飞书：

- 处理了哪些讲座
- 视频/文档下载状态和文件大小
- 压缩参数和最终体积
- 遇到的问题和解决方案
- 知识库更新情况
- 做题结果

报告模板：`reports/REPORT_TEMPLATE.md`

---

## 9. 项目管理规范

本项目遵循测试驱动开发和缺陷管理规范，包括：
- 测试驱动原则（单样本测试优先）
- 缺陷分类（严重程度+优先级）
- 小问题顺手修复、大问题讨论处理
- 缺陷管理流程（发现→分类→记录→处理→验证→关闭→报告）
- 测试计划文档模板

**详细文档**：[project-management/README.md](./project-management/README.md)

---

## 当前进度（2026-08-27 更新）

### 已完成

| 项目 | 状态 | 说明 |
|------|------|------|
| 项目目录结构 | ✅ | GitHub 仓库 byte886/cpa-course-archive（公有） |
| 全局 Skill | ✅ | gaodun-course-downloader（视频下载/压缩/网盘上传） |
| 飞书知识库 | ✅ | "CPA备考知识库"（space_id: 7678261729456852192），节点结构已搭好 |
| 百度网盘 API | ✅ | 应用"CPA课程归档"，沙箱目录 /apps/CPA课程归档/ |
| 税法-蔡俊峻 01 | ✅ | 视频下载+压缩（246MB）+ 已上传网盘 |
| 基础必修-会计（罗翔）12讲 | ✅ | 桌面手工录制视频全部压缩完成（12个，共2.4GB），输出到待整理目录 |

### 进行中

| 项目 | 状态 | 说明 |
|------|------|------|
| 视频转文字测试 | 🔄 | FunASR SenseVoiceSmall 环境已搭好，10分钟片段测试通过，整集测试进行中 |

### 待完成

- [ ] 整集转写测试通过后，批量转写全部视频
- [ ] 转写文本与讲义 PDF 合并梳理，写入飞书知识库
- [ ] 基础必修12个视频上传百度网盘
- [ ] 税法剩余 37 讲下载+压缩+上传
- [ ] 会计课程下载+压缩+上传
- [ ] 各课程讲义文档下载+文字提取
- [ ] 知识库完成后做题验证

### 视频来源说明

- **网站下载**：通过 Playwright 捕获 HLS AES-128 密钥，下载解密合并后压缩（税法01已完成）
- **手工录制**：用户之前手工录制的视频（桌面"会计基础必修08-资产"目录），作为输入源直接压缩，输出到结构化目录 `高顿/CPA/待整理/课程名/课次/video.mp4`
- 两种来源的视频压缩参数一致（H.265 CRF30 / preset fast / AAC 96k / hvc1 / faststart）

---

## 注意事项

- m3u8 token 和 authorize token 会过期，每个视频需重新捕获
- 课程表 tab 可能因内存崩溃（ffmpeg 占内存），需重新加载
- 不要在浏览器中点击"下载"按钮（会触发 Chrome 下载弹窗），直接用 curl 下载 CDN 直链
- 代理：GitHub/Homebrew/npm 需 ClashX 代理（127.0.0.1:7890），高顿课程页/百度API/百度网盘直连（Tailscale DNS 已修复）
- 密钥管理见 `scripts/secrets.sh`，加密文件在 `.secrets/`
