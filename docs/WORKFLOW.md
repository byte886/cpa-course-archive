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
- **跳过开班典礼**，不下载不建目录
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

API 参考：`skill/references/baidupan.md`，完整创建过程：`docs/BAIDU_NETDISK_SETUP.md`

---

## 5. 内容解析

### 5.1 视频转文字

待确定方案（候选：飞书妙记、Whisper 等）。

需要提取：
- **语音内容**：讲师讲课全文
- **画面内容**：PPT 画面中的文字（OCR），按时间点标注

输出为 `transcript.md`，结构：
```markdown
# 讲座标题

## 元信息
- 课程：税法-蔡俊峻
- 讲次：01
- 时长：3h15m
- 日期：2026-03-13

## 文字稿
[00:00:00] 内容...

## PPT 画面文字
[00:05:30] 幻灯片标题及要点...
```

### 5.2 文档文字提取

- PDF：`pdftotext` 或 Python pdfplumber
- PPT：python-pptx
- DOC：python-docx 或 textutil（macOS）

输出到 `docs_text/` 目录，保持文件名对应。

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

每个讲座的知识库条目完成后：

1. 进入课程表页该讲座下的"课后练习"
2. 逐题作答，验证知识库是否覆盖相关知识点
3. 错题和未覆盖的知识点补充回知识库
4. 记录做题结果到任务报告

这是一个**验证-补充闭环**，不是一次性步骤。

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

## 注意事项

- m3u8 token 和 authorize token 会过期，每个视频需重新捕获
- 课程表 tab 可能因内存崩溃（ffmpeg 占内存），需重新加载
- 不要在浏览器中点击"下载"按钮（会触发 Chrome 下载弹窗），直接用 curl 下载 CDN 直链
- 代理：GitHub/Homebrew/npm 需 ClashX 代理（127.0.0.1:7890），高顿课程页/百度API/百度网盘直连（Tailscale DNS 已修复）
- 密钥管理见 `scripts/secrets.sh`，加密文件在 `.secrets/`
