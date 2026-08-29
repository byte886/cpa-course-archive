# AGENTS.md — AI代理操作手册

> **文档类型**：Governance（治理规范 — AI操作手册）
> **更新频率**：每次流程/工具/规范变更时
> **维护者**：AI自动维护 + 用户审核
> **读者**：AI代理（每次启动自动加载）

> 本文档是AI代理的操作手册，命令式、可执行。与README.md（给人看的项目介绍）互补。
> 执行任何任务前必须先阅读本文档对应部分，**核心规则在第3章，必须优先阅读**。
>
> **写作原则**：基于 [AGENTS_MD_BEST_PRACTICES.md](docs/development/guides/AGENTS_MD_BEST_PRACTICES.md)，只包含AI无法推断的内容，已在其他文档中的内容只链接不重复。

---

## 1. 文档边界

| 维度 | 本文档（AGENTS.md） | 其他文档 |
|------|---------------------|----------|
| **定位** | AI操作手册，命令式、可执行 | - |
| **读者** | AI代理（每次启动自动加载） | - |
| **包含** | 核心规则、执行前必读、禁止事项、工具版本、常用命令、异常处理 | - |
| **不包含** | 项目目标介绍、存储分工、课程列表 | → [README.md](README.md) |
| **不包含** | 详细操作流程、各环节步骤 | → [docs/WORKFLOW.md](docs/WORKFLOW.md) |
| **不包含** | 需求定义、功能清单、验收标准 | → [docs/REQUIREMENTS.md](docs/REQUIREMENTS.md) |
| **不包含** | 编码规范 | → [docs/development/guides/CODE_STYLE.md](docs/development/guides/CODE_STYLE.md) |
| **不包含** | 目录结构详细说明 | → [docs/DIRECTORY_STRUCTURE.md](docs/DIRECTORY_STRUCTURE.md) |
| **不包含** | 系统要求与环境配置 | → [docs/SYSTEM_REQUIREMENTS.md](docs/SYSTEM_REQUIREMENTS.md) |

---

## 2. 执行前必读文档（强制顺序）

**执行任何任务前，必须按以下顺序查阅文档，未查阅不得开始执行：**

1. **先读 `README.md`** — 了解项目概览、存储分工、课程列表、常用查询话术
   （核心规则已在本文档第3章，无需重复阅读）
2. **再读 `docs/REQUIREMENTS.md`** — 理解项目目标、功能范围、验收标准
3. **再读 `docs/WORKFLOW.md` 对应环节** — 找到当前任务所属的流程环节，阅读详细步骤
4. **按 WORKFLOW 中的「参考文档」链接查阅专项文档** — 如做题交互规范、压缩参数说明等
5. **最后检查 `project-management/active/TASK_STATUS.md`** — 确认当前任务状态和前置依赖

**参考资料（按需查阅，不需要每次都读）：**
- `docs/DIRECTORY_STRUCTURE.md` — 目录结构详细说明
- `docs/SYSTEM_REQUIREMENTS.md` — 系统要求与环境配置
- `docs/DOCUMENTATION_MAP.md` — 文档地图（所有文档索引）
- `docs/project-management/decisions/` — 架构决策记录（ADR），做重要决策前先查看历史决策，避免冲突

**为什么必须这样做**：本项目流程复杂，每个环节都有专项文档记录了踩过的坑和优化方案。不查阅文档直接执行，大概率会重复犯之前已经解决过的错误。文档是项目的"集体记忆"，必须依赖文档而不是对话记忆。

---

## 3. 核心规则（强制，必须遵守）

### 3.1 问题驱动更新（强制）

发现任何问题（文件位置不对、脚本有bug、流程有缺陷、文档缺失等）时，必须立即评估是否需要更新文档或自动化检查，评估后必须执行，不能只发现问题不更新。

### 3.2 小问题顺手修复，大问题讨论处理

- **小问题**（文档链接错误、文件名不对、简单脚本bug）：顺手修复，并记录到任务报告
- **大问题**（流程变更、架构调整、新增功能）：先和用户讨论，确认方案后再执行

### 3.3 定期检查项目结构

每次开始新任务前、完成大任务后，必须检查项目结构是否合理，发现问题主动梳理调整。

### 3.4 写文档前必须检查文档组织（强制）

**遇到问题需要写文档、更新文档或新增内容时，必须先检查项目文档组织和分工，禁止直接写到任意文档中。**

**检查流程**：
1. 查看文档目录结构：`ls -la docs/`
2. 查找相关文档：用 `grep -r "关键词" docs/` 查找是否已有相关内容
3. 确认文档分工（见本文档第1章）
4. 选择正确的文档，WORKFLOW.md只放概览和链接
5. 确保文档关联：新增或更新后，确保相关文档之间有链接

### 3.5 文档同步规则（强制）

每次完成阶段性任务、生成新文档、或变化项目结构时，必须按 `docs/project-management/standards/DOC_SYNC_CHECKLIST.md` 检查并同步相关文档。

**同步时机**：完成单个讲座流程后 / 完成所有试卷后 / 发现问题并解决后 / 项目结构调整后 / 大阶段完成后

**核心原则**：本地文档为主，飞书表格为辅；问题驱动更新，发现问题立即评估是否需要更新文档。

### 3.6 大任务执行状态记录（强制）

**开始任何大任务前，必须先创建执行状态记录，异常恢复时必须先读取状态记录。**

**详细规范**：`docs/project-management/standards/BATCH_TASK_EXECUTION.md`

**必须创建执行状态记录的场景**：
1. 批量处理 >3 个讲次
2. 预计执行时间 >1 小时
3. 涉及多个工具链（Playwright + ffmpeg + FunASR + 飞书API等）
4. 用户明确要求"批量处理"、"全部完成"

### 3.7 清理与维护原则

- 测试文件、临时日志、残留目录及时清理
- 完成任务后检查是否有中间产物需要清理
- 不要在项目根目录散落临时文件
- **文件和目录有变化时必须检查 .gitignore**：新增/移动/删除文件或目录后，检查 .gitignore 是否需要更新
- **提交前运行 `git status` 检查**：确认没有不该提交的文件
- **发现新文件类型时及时补充**：遇到之前没有的文件类型，必须检查是否需要添加到 .gitignore

### 3.8 知识库生成规则（强制）

**详细规范**：`docs/development/knowledge/knowledge-base-organization.md`

**核心规则**：
1. **本地是唯一源头**：所有知识库内容必须先在本地 `knowledge-base/organized-content/` 完成并验证，再同步到飞书，禁止直接修改飞书
2. **父节点必须含子节点链接**：章节父节点的内容中必须包含知识拆解和考试指导的链接
3. **通用方法独立目录**：面向所有课程的通用方法论放在 `knowledge-base/organized-content/通用方法/` 目录
4. **验证报告不上传飞书**：`VERIFICATION_*.md` 和 `SYNC_REPORT_*.md` 仅本地保留
5. **子节点内容更新后同步父节点**：当知识拆解或考试指导内容更新时，父节点的概览内容也需要同步更新
6. **冲突处理**：当用户留言与讲义内容冲突时，以讲义为准

---

## 4. Things to Avoid（明确禁止事项）

### 4.1 操作禁止

- ❌ **不要用Chrome浏览器手动下载文件**——必须用脚本（`scripts/download_decrypt.js`或curl）后台下载
- ❌ **不要在一个Bash命令中做多道题**——每个命令只做一道题，避免超时移到后台导致输出丢失
- ❌ **不要用ref点击多选题的第二个及以后选项**——ref会失效，必须用 `scripts/answer_multi.sh`（JavaScript直接点击）
- ❌ **不要跳过"做题前查询知识库"步骤**——必须先读对应知识库文档再答题
- ❌ **不要自行关闭用户打开的Chrome窗口**——只关闭Playwright管理的多余tab页

### 4.2 文档禁止

- ❌ **不要把详细技术内容写到WORKFLOW.md**——WORKFLOW只放概览和链接
- ❌ **不要不检查已有文档就新建文档**——先用 `grep -r "关键词" docs/` 查找
- ❌ **不要把交互规范写到技术文档中，或把技术规范写到交互文档中**
- ❌ **不要新增内容后不更新相关文档的链接**

### 4.3 流程禁止

- ❌ **不要不查阅文档就直接执行**——必须先读AGENTS.md → README.md → WORKFLOW.md对应环节 → 专项文档
- ❌ **不要操作失败就直接要求用户手动操作**——必须先查文档、尝试自动修复，无法解决再请求帮助
- ❌ **不要大任务不创建执行状态记录就开始**——批量>3个讲次或预计>1小时必须先创建状态记录
- ❌ **不要把生成结果（视频/PDF/文字稿）提交到GitHub**——.gitignore已忽略，不要强制添加

---

## 5. 浏览器操作任务强制检查清单

**开始任何需要浏览器操作的任务前，必须按以下清单逐项检查：**

| 序号 | 检查项 | 检查方法 | 处理方式 |
|------|--------|----------|----------|
| 1 | 关闭无关tab页 | `npx playwright cli -s=ga tab-list` | 超过2个tab时，关闭除工作页面外的所有页面 |
| 2 | 检查Playwright连接状态 | `npx playwright cli -s=ga tab-list` | 如果报错，执行连接恢复流程 |
| 3 | 连接失败自动刷新Token | 连接超时或报错 | 按 `docs/development/tools/playwright-cli-guide.md` 第4节自动刷新，**禁止直接要求用户手动操作** |
| 4 | 检查当前页面是否正确 | `npx playwright cli -s=ga eval "() => window.location.href"` | 如果不是目标页面，导航到正确URL |
| 5 | 检查任务前置依赖 | 查看 `TASK_STATUS.md` | 确认前置任务已完成 |

---

## 6. 存储分工（硬约束）

| 位置 | 内容 | 说明 |
|------|------|------|
| GitHub仓库 | 代码+文档 | **禁止**放视频、PDF、文字稿等生成结果 |
| 本地 `~/Desktop/高顿/` | 视频、讲义、文字稿 | 生成结果的主存储 |
| 百度网盘 | 与本地完全镜像 | 备份+跨设备访问 |
| 飞书知识库 | 知识梳理内容 | 结构化知识，面向学习 |
| 飞书文档 | 任务报告 | 过程记录 |

> 详细的目录结构说明见 [docs/DIRECTORY_STRUCTURE.md](docs/DIRECTORY_STRUCTURE.md)。

---

## 7. 异常处理流程（任何操作失败时）

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

## 8. 文档快速入口

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
| 编码规范 | `docs/development/guides/CODE_STYLE.md` | - |
| OCR识别 | `docs/development/tools/ocr.md` | - |
| 飞书API | `docs/development/api/feishu-api.md` | - |

---

## 9. 状态查询协议（收到用户查询时必须遵守）

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

## 10. Definition of Done（任务完成标准）

任务完成前，必须逐项验证：

- [ ] 所有生成文件已验证可用（视频可播放、文字稿无明显错误、知识库内容准确）
- [ ] 所有错题已分析原因（知识错误→检查知识库，交互错误→修复脚本）
- [ ] 相关文档已同步（按DOC_SYNC_CHECKLIST.md检查）
- [ ] 临时文件已清理
- [ ] 任务状态已更新（TASK_STATUS.md）
- [ ] 生成结果已上传到对应位置（本地+百度网盘+飞书知识库，按存储分工）

---

*本文档随项目演进持续更新。发现规则缺失或不准确时，按"问题驱动更新"原则立即补充。*
