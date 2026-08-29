# 工作流文档

> **文档类型**：Task（操作指南 — 主工作流）
> **更新频率**：每次流程变更时
> **维护者**：AI自动维护 + 用户审核
> **读者**：AI代理（执行任务前必读）和人类（了解流程时）

本文档是CPA课程归档项目的**主工作流索引**，只保留总体流程、全局规则和每个环节的摘要+参考文档链接。详细操作步骤、参数、常见问题请查阅对应专项文档。

---

## 文档边界

| 维度 | 本文档（WORKFLOW.md） | 其他文档 |
|------|---------------------|----------|
| **定位** | 主工作流索引，操作流程指南 | - |
| **读者** | AI代理（执行任务前必读）和人类（了解流程时） | - |
| **包含** | 总体流程、全局规则、各环节摘要+参考文档链接 | - |
| **不包含** | 项目目标介绍、存储分工、课程列表 | → [README.md](../README.md) |
| **不包含** | AI执行规则、命令、Things to Avoid | → [AGENTS.md](../AGENTS.md) |
| **不包含** | 需求定义、功能清单、验收标准 | → [REQUIREMENTS.md](REQUIREMENTS.md) |
| **不包含** | 文档索引、所有文档清单 | → [DOCUMENTATION_MAP.md](DOCUMENTATION_MAP.md) |
| **不包含** | 各环节详细操作步骤、参数、常见问题 | → 对应专项文档（development/下） |

---

## 总体流程

```
建目录 → 下载视频 → 下载文档 → 同步网盘 → 内容解析 → 知识库(第一阶段：初始生成) → 做题验证 → 知识库(第二阶段：迭代更新) → 任务报告
```

**知识库两阶段生成说明：**

| 阶段 | 内容 | 来源 | 输出 |
|------|------|------|------|
| **第一阶段：初始生成** | 基于讲义和视频内容生成知识拆解和考试指导 | 讲义OCR + 视频音频转写 | 初始知识库（知识拆解 + 考试指导） |
| **第二阶段：迭代更新** | 基于做题过程补充易错点、记忆口诀、真题解析、用户笔记精华 | 做题记录 + 用户笔记 + 官方解析 + 错题分析 | 更新后的知识库 |

每个讲座独立走完一遍流程，完成后再进入下一个。

---

## 全局规则（所有环节必须遵守）

### 大任务检查时间约定（必须遵守）

所有长时间运行的任务（视频压缩、OCR、音频转写、批量上传等），**最大5分钟检查一次进度**，禁止等待10分钟以上不检查。

**检查内容**：进程是否在运行、输出文件大小是否增长、最新进度、是否有错误日志。

**异常处理**：进程异常退出→删除不完整文件→重新启动；文件大小不增长但进程还在→检查是否卡住→必要时重启。

### 窗口管理规则（必须遵守）

开启新的iTerm窗口或Chrome TAB前，**必须先检查并关闭未使用的窗口/TAB**。

- **iTerm**：任务完成后立即关闭对应窗口，禁止累积未使用窗口
- **Chrome TAB**：开始新任务前关闭无关TAB，视频下载完成后立即关闭播放TAB
- 详细操作命令：参考 [interaction-workflow.md](development/guides/interaction-workflow.md) 第1节

### 统一使用已有工具（必须遵守）

项目中已有成熟的脚本和工具，**禁止重复创建或使用其他工具**。

| 任务 | 统一使用的工具 |
|------|--------------|
| 视频下载解密 | `scripts/download_decrypt.js` |
| 视频压缩 | `scripts/compress.sh` |
| 讲义OCR | `scripts/batch_ocr.sh` |
| 音频转写 | `scripts/transcribe_pipeline.py` |
| 网盘上传 | `scripts/baidu_upload.py` |
| 做题（单选） | `scripts/answer_option.sh` |
| 做题（多选） | `scripts/answer_multi.sh` |
| 交卷 | `scripts/submit_exam.sh` |

**完整脚本索引**：[scripts/README.md](../scripts/README.md)

### 重要决策前查看历史ADR（必须遵守）

做任何重要决策（目录结构调整、工具选择、流程变更、文档分解等）前，**必须先查看 [ADR索引](../project-management/decisions/README.md)**，了解历史决策，避免做出冲突的决策。

**必须查看ADR的场景**：
1. 项目目录结构重大调整
2. 核心工具/技术栈变更
3. 工作流重大变更
4. 存储分工变更
5. 知识库组织结构变更
6. 文档分解/合并

**查看方式**：
1. 先读 `docs/project-management/decisions/README.md`（ADR索引）
2. 找到相关的ADR，阅读背景、决策、后果
3. 如果新决策与历史决策冲突，评估是否需要废弃历史ADR或调整新决策
4. 如果是新的重要决策，执行后必须记录新的ADR

### 文档健康度检查（必须遵守）

**每次大任务完成后，必须执行文档健康度检查，确保文档体系的完整性、关联性和质量。**

**详细规范**：[DOCUMENTATION_OPTIMIZATION.md 第十二章](project-management/standards/DOCUMENTATION_OPTIMIZATION.md)

**必须执行文档健康度检查的场景**：
1. 每个课程/每个大任务完成后
2. 项目结构重大调整后
3. 新增/删除/移动大量文档后
4. 用户明确要求检查时

**检查内容**：
1. 完整性：所有文档是否在DOCUMENTATION_MAP.md中有记录，新增文档是否有类型标注
2. 关联性：文档中的链接是否有效，是否存在文档孤岛
3. 结构：目录结构是否与DIRECTORY_STRUCTURE.md一致，是否存在空目录
4. 质量：是否存在重叠内容，大文档是否需要分解
5. 维护：.gitignore是否合理，核心文档是否最新

**自动化保障**：
- pre-commit hook自动检查文档关联性和类型标注
- 每次git提交前自动触发，不需要手动执行

---

## 1. 建目录

### 摘要

按规范创建课程目录结构，检查作业情况，管理浏览器和iTerm窗口资源。

### 关键要点

- 目录结构：`高顿/CPA/课程库/<课程名>/<序号>_<章节名>/`（包含video.mp4、transcript.md、docs/、docs_text/）
- 开班典礼用序号00，作为课程的第一讲处理
- "待整理"中的课程走完知识库流程后，移动到"课程库"下
- 建目录时必须检查该讲次是否有课后作业（"继续考"），并在任务报告中明确说明
- 创建目录前必须验证命名规范，禁止创建不完整命名的空目录

### 参考文档

- **命名规范**：[NAMING_CONVENTION.md](project-management/standards/NAMING_CONVENTION.md) — 目录和文件命名的完整规范
- **资源管理**：[interaction-workflow.md](development/guides/interaction-workflow.md) — Chrome TAB和iTerm窗口管理
- **目录检查脚本**：`scripts/check_directory_structure.sh` — 自动检测并清理不完整命名的空目录

---

## 1.6 Playwright 浏览器连接（所有浏览器操作的前置步骤）

### 摘要

使用Extension模式附加到用户已登录的Chrome，禁止用`open`打开新窗口（新窗口没有登录状态）。

### 关键要点

- 推荐使用连接脚本自动处理：`bash scripts/playwright_connect.sh`
- 操作前必须关闭不相关的tab页
- 第一次连接需要手动点击"Allow & select"按钮（Chrome扩展安全机制），之后会被记住
- 连接失败时自动刷新Token，禁止直接要求用户手动操作
- 连接成功后验证当前页面是否为高顿网站

### 参考文档

- **完整指南**：[playwright-cli-guide.md](development/tools/playwright-cli-guide.md) — 正确用法、常见错误、Token自动刷新流程、命令速查表
- **连接脚本**：`scripts/playwright_connect.sh` — 自动检测并处理连接确认

---

## 2. 下载视频

### 摘要

捕获HLS加密视频的密钥和m3u8播放列表，下载分片、AES-128解密、合并为完整视频，然后用H.265 CRF30压缩。

### 关键要点

- 用Worker hook脚本（`scripts/capture_key.js`）截获m3u8 URL、AES密钥、IV
- 切换到1080P分辨率后再捕获
- 多线程下载.ts分片，支持断点续传，AES-128-CBC解密
- 压缩参数：libx265 / CRF 30 / preset fast / AAC 96k / hvc1标签 / faststart
- 压缩必须在iTerm中运行，可实时查看ffmpeg进度
- 压缩后验证：时长与原片一致（误差<1秒）、moov atom存在、播放器实际播放检查开头无黑屏

### 参考文档

- **完整指南**：[video-processing.md](development/tools/video-processing.md) — 前置条件、加密方案逆向分析、详细操作流程、关键陷阱汇总、CRF测试结果
- **下载脚本**：`scripts/download_decrypt.js` — HLS分片下载解密合并
- **压缩脚本**：`scripts/compress.sh` — ffmpeg批量压缩（支持单文件和目录）

---

## 3. 下载文档

### 摘要

从课程表页获取讲义/课件的CDN直链，用curl后台下载，禁止用Chrome点击下载按钮（会弹出下载对话框）。

### 关键要点

- ⚠️ **强制规则**：禁止用Chrome点击下载按钮！必须用curl后台下载！
- 用Playwright的`run-code`监听网络请求，点击下载按钮时捕获CDN直链
- CDN域名：`simg01.gaodunwangxiao.com/newoss/resources/...`，PDF可直接curl下载，无需认证
- 如果出现Chrome下载对话框，立即取消（按Esc或点击取消），删除已下载文件，用curl重新下载
- 文档格式可能是PDF、PPT、DOC等，以实际下载为准
- 下载后对照课程清单核对文档数量，检查文件大小
- 高顿课件PDF多为图片型PDF，必须使用OCR提取文字（详见第5.2节）

### 参考文档

- **OCR指南**：[ocr.md](development/tools/ocr.md) — macOS Vision框架OCR、PDF转图片、表格/图表AI补充
- **批量OCR脚本**：`scripts/batch_ocr.sh`

---

## 4. 同步百度网盘

### 摘要

将本地课程文件上传到百度网盘，保持目录结构与本地完全一致。

### 关键要点

- 应用：CPA课程归档（AppID: 124199604），沙箱目录：`/apps/CPA课程归档/`
- 凭证：`.secrets/baidu_credentials.enc`（AES-256-CBC加密）
- API直连即可，不需要代理
- 上传流程：解密获取access_token → 按目录结构创建文件夹 → 分片上传（precreate → upload 4MB分片 → create）→ 上传后list验证
- 网盘路径必须包含`高顿/`层，与本地目录结构完全一致
- 上传完成后必须验证文件大小与本地一致

### 参考文档

- **完整指南**：[netdisk-setup.md](development/api/netdisk-setup.md) — 应用创建、API配置、上传脚本使用、常见问题
- **上传脚本**：`scripts/baidu_upload.py`（单文件）、`scripts/batch_upload.sh`（批量）、`scripts/upload_course.sh`（完整课程）

---

## 5. 内容解析

### 摘要

将视频音频转写为文字，将讲义文档（图片型PDF）通过OCR提取文字，为知识库生成提供素材。

### 5.1 视频转文字

- **方案**：阿里FunASR（SenseVoiceSmall），开源本地方案，0成本
- 中文CER 8-10%，VAD加速后约15x实时（2.5小时视频约10分钟）
- 虚拟环境：`transcription/venv/`，脚本：`scripts/transcribe_pipeline.py`（单视频）、`scripts/batch_transcribe.sh`（批量）
- 必须在iTerm中运行（可开多个窗口并行）

### 5.2 文档文字提取（OCR）

- **方案**：macOS Vision框架OCR（系统原生免费），**不是tesseract**
- 工具：Swift编译的`/tmp/ocr_vision` + PyMuPDF（200 DPI）
- 性能：116页约2分钟，每页约1秒
- 遇到表格/公式/图表时用AI视觉补充识别
- 批量脚本：`scripts/batch_ocr.sh`

### 参考文档

- **转写指南**：[transcription.md](development/tools/transcription.md) — FunASR环境配置、性能数据、脚本使用
- **OCR指南**：[ocr.md](development/tools/ocr.md) — macOS Vision框架、PDF转图片、表格图表AI补充

---

## 6. 梳理到飞书知识库（两阶段生成）

### 摘要

基于讲义OCR和视频转写生成初始知识库（第一阶段），通过做题验证后迭代更新知识库（第二阶段）。

### 关键要点

- **原则：先本地，后飞书；先验证，后同步。** 所有知识库内容的变更必须先在本地文档中完成，验证通过后再同步到飞书
- **知识库结构**：CPA/课程库/<课程名>/<章节名>/知识拆解 + 考试指导
- **节点命名**：章节名带两位序号（01税法总论），开班典礼用00序号，每个章节下固定两个子文档
- **内容分工**：知识拆解=章节核心知识点（定义、分类、原则、表格）；考试指导=做题技巧、易错点、记忆口诀、高频考点
- **父节点规范**：课程节点和章节节点必须包含子节点目录清单（可点击链接+简要说明）、章节概述、重点内容、学习建议
- **整理原则**：按知识点而非视频时间线组织；视频语音+PPT画面+讲义文档三者交叉印证；用户留言与讲义冲突时以讲义为准
- **同步后必须执行结构检查**：节点层级、重复节点、空节点、父节点链接、独立文档检查
- **禁止直接在飞书知识库中编辑内容**（除非紧急修复），必须用API同步

### 参考文档

- **组织结构**：[knowledge-base-organization.md](development/knowledge/knowledge-base-organization.md) — 知识库结构设计、节点命名、内容分工、父节点规范、模板
- **来源清单**：[knowledge-base-sources.md](development/knowledge/knowledge-base-sources.md) — 知识库来源清单、来源选择流程、同步流程、发展重设计原则
- **飞书API**：[feishu-api.md](development/api/feishu-api.md) — 飞书API调用方法、权限配置、常见问题
- **知识库模板**：[KNOWLEDGE_BASE_TEMPLATE.md](knowledge-base/KNOWLEDGE_BASE_TEMPLATE.md)

---

## 7. 做题验证知识库

### 摘要

通过做题检验知识库是否覆盖所有考点，错题和未覆盖的知识点补充回知识库，形成验证-补充闭环。

### 关键要点

- **试卷类型**：每个章节有8套试卷（7套课后练习按考点分 + 1套分章真题测）
- **执行顺序**：先做7套课后练习（按考点顺序），再做1套分章真题测
- **⚠️ 总考试触发条件**：总考试（冲刺模考卷）必须在所有课程/讲座学习完成后才能做
- **做题前必须查询知识库**：先根据知识库内容学习，查询相关知识点，记录查询结果，然后再应答（禁止凭记忆答题）
- **每道题做完后必须检查是否选择了对应答案（蓝色标记）**，确认后才能进行下一步
- **单选题**自动跳题，**多选题**需手动点击"下一题"
- **补题流程**（发现未做题时）：记录所有未做题编号→通过答题卡依次点击未做题编号补做（不要从头依次做，避免反向取消已做题）→中途不交卷，完成所有未做题后才交卷
- **获取全部解析**：逐题点击"下一题"遍历所有题目，获取官方解析和用户留言
- **错题补充**：知识点缺失→补充到知识拆解；易错点/陷阱/解题技巧→补充到考试指导；知识库表述不准确→修正知识库内容
- **用户留言处理**：高赞留言（点赞≥5）重点整理，可能包含记忆口诀、易错点总结；与讲义冲突时以讲义为准

### 冲刺模考（阶段二）

所有课程完成后进入冲刺模考阶段：视频解析（走与一般课程相同的完整流程）→ 机考（交互方式与一般考试不同，待模拟时补充）→ 知识库迭代更新。

### 参考文档

- **做题流程与交互规范**：[exam-workflow.md](development/guides/exam-workflow.md) — ⚠️ **必读**：页面管理、补题流程、答题卡操作、v4 JavaScript方法、检查清单、试卷统计
- **做题思路解析**：[做题思路解析.md](knowledge-base/organized-content/做题思路解析.md) — 通用做题方法论（面向学习者）
- **做题脚本**：`scripts/answer_option.sh`（单选）、`scripts/answer_multi.sh`（多选）、`scripts/submit_exam.sh`（交卷）

---

## 8. 任务报告

每次批量任务完成后生成报告，记录到飞书文档，内容包括：

- 处理了哪些讲座
- 视频/文档下载状态和文件大小
- 压缩参数和最终体积
- 遇到的问题和解决方案
- 知识库更新情况
- 做题结果

**报告模板**：[REPORT_TEMPLATE.md](../docs/development/templates/REPORT_TEMPLATE.md)

---

## 9. 项目管理规范

本项目遵循测试驱动开发和缺陷管理规范，包括：
- 测试驱动原则（单样本测试优先）
- 缺陷分类（严重程度+优先级）
- 小问题顺手修复、大问题讨论处理
- 缺陷管理流程（发现→分类→记录→处理→验证→关闭→报告）

**详细文档**：[project-management/README.md](project-management/README.md)

---

## 注意事项

- m3u8 token和authorize token会过期，每个视频需重新捕获
- 课程表tab可能因内存崩溃（ffmpeg占内存），需重新加载
- 不要在浏览器中点击"下载"按钮（会触发Chrome下载弹窗），直接用curl下载CDN直链
- 代理：GitHub/Homebrew/npm需ClashX代理（127.0.0.1:7890），高顿课程页/百度API/百度网盘直连
- 密钥管理见`scripts/secrets.sh`，加密文件在`.secrets/`

---

*本文档是主工作流索引，只保留总体流程和摘要。详细操作步骤请查阅各环节的参考文档。新增或变更流程时，必须同步更新本文档和对应专项文档。*
