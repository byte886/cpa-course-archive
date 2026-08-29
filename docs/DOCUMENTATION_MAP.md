# 文档地图（DOCUMENTATION MAP）

> **文档类型**：Reference（参考资料 — 文档索引）
> **更新频率**：每次新增/删除/移动文档时
> **维护者**：AI自动维护
> **读者**：AI代理（快速定位文档）和人类（查找文档时）

> 本文档是项目所有文档的导航入口，告诉AI和人"先读什么、去哪里找什么"。
> 类似 llms.txt 的作用：文档地图，快速定位。

---

## 快速入口（按场景）

### 开始新任务前
1. `AGENTS.md` — AI操作手册（必读）
2. `README.md` — 项目概览、存储分工
3. `docs/REQUIREMENTS.md` — 项目需求文档（核心诉求、功能需求、验收标准）
4. `docs/WORKFLOW.md` — 主工作流，找到当前任务所属环节
5. `docs/project-management/active/TASK_STATUS.md` — 当前任务状态和前置依赖

### 做题验证前
1. `docs/development/guides/exam-workflow.md` — 做题流程与交互规范（含交互优化、检查清单、v4 JavaScript方法）
2. `knowledge-base/organized-content/<章节名>/知识拆解.md` — 知识库内容
3. `knowledge-base/organized-content/<章节名>/考试指导.md` — 考点分析、易错点
4. `knowledge-base/organized-content/做题思路解析.md` — 通用做题方法论
5. `scripts/answer_option.sh` / `scripts/answer_multi.sh` / `scripts/submit_exam.sh` — 做题脚本

### 视频下载/压缩
1. `docs/WORKFLOW.md` 第2节
2. `docs/development/tools/video-processing.md` — 压缩参数、CRF测试结果
3. `scripts/compress.sh` — 压缩脚本

### 文档下载
1. `docs/WORKFLOW.md` 第3节
2. `docs/development/tools/document-download.md` — CDN直链获取、curl后台下载、完整性校验
3. `scripts/batch_ocr.sh` — OCR脚本（下载后提取文字）

### 视频转文字
1. `docs/WORKFLOW.md` 第5节
2. `docs/development/tools/transcription.md` — 转写方案对比、FunASR使用
3. `scripts/transcribe_pipeline.py` — 转写管道

### 知识库生成
1. `docs/WORKFLOW.md` 第6节
2. `docs/development/knowledge/knowledge-base-organization.md` — 知识库组织结构
3. `docs/development/knowledge/knowledge-base-sources.md` — 知识库来源清单
4. `docs/development/templates/KNOWLEDGE_BASE_TEMPLATE.md` — 知识库模板

### 百度网盘同步
1. `docs/WORKFLOW.md` 第4节
2. `docs/development/api/netdisk-setup.md` — 网盘API配置、上传脚本使用
3. `scripts/baidu_upload.py` — 上传脚本

### 遇到问题/异常
1. `grep -rn "关键词" docs/` — 搜索相关文档
2. `docs/development/tools/playwright-cli-guide.md` — Playwright常见问题
3. `docs/development/guides/interaction-workflow.md` — 交互异常处理
4. `AGENTS.md` 第10节 — 异常处理流程

### 项目维护/文档更新
1. `docs/project-management/standards/PROJECT_MAINTENANCE.md` — 维护规范、文档组织、Docs as Code
2. `docs/project-management/standards/PROJECT_STATUS_QUERY.md` — 状态查询协议、意图分类、模糊表达映射、标准响应格式
3. `docs/project-management/standards/DOC_SYNC_CHECKLIST.md` — 文档同步清单
4. `docs/project-management/standards/NAMING_CONVENTION.md` — 命名规范

---

## 文档完整清单（按类型分类）

### 零、标准开源文档（根目录）

| 文档 | 路径 | 用途 |
|------|------|------|
| 项目介绍 | `README.md` | 项目目标、存储分工、目录结构 |
| AI操作手册 | `AGENTS.md` | 全局执行规则、Things to Avoid、技术栈、设置命令 |
| 变更日志 | `CHANGELOG.md` | 版本变更记录（Keep a Changelog格式） |
| 贡献指南 | `CONTRIBUTING.md` | 贡献流程、代码规范、提交信息规范 |
| 开源协议 | `LICENSE` | MIT协议 |
| GitHub模板 | `.github/ISSUE_TEMPLATE/`、`.github/PULL_REQUEST_TEMPLATE.md` | Issue和PR模板 |

### 一、操作指南（Task — 怎么做）

| 文档 | 路径 | 用途 |
|------|------|------|
| 主工作流 | `docs/WORKFLOW.md` | 全流程概览，各环节的操作步骤 |
| 视频处理 | `docs/development/tools/video-processing.md` | 下载、压缩、参数调优 |
| OCR讲义 | `docs/development/tools/ocr.md` | PDF/PPT/DOC文字提取 |
| 音频转写 | `docs/development/tools/transcription.md` | FunASR方案、环境配置 |
| 网盘操作 | `docs/development/api/netdisk-setup.md` | 百度网盘API配置与上传 |
| 飞书API | `docs/development/api/feishu-api.md` | 知识库、文档、多维表格API |
| 加密凭证 | `docs/development/api/encryption.md` | Token加密存储与使用 |
| Git工作流 | `docs/development/guides/git-workflow.md` | 分支策略、提交规范、pre-commit |
| Playwright指南 | `docs/development/tools/playwright-cli-guide.md` | CLI使用、Token刷新、常见问题 |
| 交互工作流 | `docs/development/guides/interaction-workflow.md` | 通用页面交互、异常恢复、卡住处理 |
| **做题流程与交互规范** | `docs/development/guides/exam-workflow.md` | 做题规范、多选题处理、v4 JavaScript方法、检查清单、试卷统计（合并了原交互优化指南） |
| 文档下载 | `docs/development/tools/document-download.md` | CDN直链、curl后台下载、完整性校验 |

### 二、概念说明（Concept — 是什么）

| 文档 | 路径 | 用途 |
|------|------|------|
| 项目介绍 | `README.md` | 项目目标、存储分工、目录结构 |
| **项目需求文档** | `docs/REQUIREMENTS.md` | 核心诉求、功能需求、非功能需求、特殊规则、验收标准 |
| 知识库组织结构 | `docs/development/knowledge/knowledge-base-organization.md` | 知识库设计原则、节点层次 |
| 知识库来源清单 | `docs/development/knowledge/knowledge-base-sources.md` | 知识库内容来源、优先级 |
| 项目维护规范 | `docs/project-management/standards/PROJECT_MAINTENANCE.md` | Docs as Code、文档分解原则 |
| 质量保证规范 | `docs/project-management/standards/QUALITY_ASSURANCE.md` | 验证标准、质量检查流程 |
| 项目计划 | `docs/project-management/standards/PROJECT_PLAN.md` | 阶段划分、里程碑 |

### 三、参考资料（Reference — 查什么）

| 文档 | 路径 | 用途 |
|------|------|------|
| 知识库模板 | `docs/development/templates/KNOWLEDGE_BASE_TEMPLATE.md` | 知识拆解/考试指导模板 |
| 父节点模板 | `docs/development/templates/PARENT_NODE_TEMPLATE.md` | 知识库父节点内容模板 |
| 命名规范 | `docs/project-management/standards/NAMING_CONVENTION.md` | 文件、目录、变量命名 |
| 文档同步清单 | `docs/project-management/standards/DOC_SYNC_CHECKLIST.md` | 同步时机、更新内容 |
| 状态查询协议 | `docs/project-management/standards/PROJECT_STATUS_QUERY.md` | 意图分类、模糊表达映射、标准响应格式 |
| 大任务执行规范 | `docs/project-management/standards/BATCH_TASK_EXECUTION.md` | 检查点、预警、异常恢复 |
| 脚本说明 | `scripts/README.md` | 所有脚本的用途、参数、可靠性 |
| 开发文档索引 | `docs/development/README.md` | 开发文档快速索引 |
| 项目管理索引 | `docs/project-management/README.md` | 项目管理文档快速索引 |
| 报告模板 | `reports/README.md`、`docs/development/templates/REPORT_TEMPLATE.md` | 任务报告模板 |
| 验证报告模板 | `docs/development/templates/VERIFICATION_TEMPLATE.md`、`docs/development/templates/VERIFICATION_TEMPLATE_knowledge_base.md` | 验证报告模板 |

### 四、过程记录（Active — 做了什么）

> **说明**：这类文档是"过程记录"和"原始素材"，记录任务执行过程中的状态和产出。**不要求被其他文档交叉引用**（这是正常的，不是"文档孤岛"）。它们的价值在于可追溯性，需要时通过目录结构查找。

| 文档 | 路径 | 用途 |
|------|------|------|
| 任务状态 | `docs/project-management/active/TASK_STATUS.md` | 当前任务进度（唯一权威来源） |
| 问题/BUG跟踪 | `docs/project-management/active/ISSUES.md` | 未解决问题、已解决问题、潜在风险 |
| 批量任务状态 | `docs/project-management/active/BATCH_TASK_STATUS.md` | 大任务执行进度、恢复点 |
| 课程索引 | `docs/project-management/active/COURSE_INDEX.md` | 所有课程清单、进度、资源位置 |
| 测试计划 | `docs/project-management/test-plans/TEST_PLAN_*.md` | 各课程测试计划 |
| 验证报告 | `docs/project-management/active/verification-reports/VERIFICATION_*.md` | 各课程验证结果 |
| 决策记录（ADR） | `docs/project-management/decisions/ADR-*.md` | 重要决策的背景、原因、后果 |
| 做题记录（原始素材） | `knowledge-base/source-materials/*/做题记录_*.md` | 各章节做题过程记录（不要求引用） |
| 解析与用户留言（原始素材） | `knowledge-base/source-materials/*/解析与用户留言_*.md` | 官方解析和用户留言采集（不要求引用） |
| 用户笔记精华（原始素材） | `knowledge-base/source-materials/*/用户笔记精华_*.md` | 用户留言精华整理（不要求引用） |
| 任务报告 | `reports/REPORT_*.md` | 各任务执行报告（不要求引用） |

### 五、治理规范（Governance — 规则）

| 文档 | 路径 | 用途 |
|------|------|------|
| AI操作手册 | `AGENTS.md` | 全局执行规则、Things to Avoid |
| 项目需求文档 | `docs/REQUIREMENTS.md` | 核心诉求、功能需求、验收标准 |
| 大任务执行规范 | `docs/project-management/standards/BATCH_TASK_EXECUTION.md` | 检查点、预警、异常恢复 |
| 文档同步清单 | `docs/project-management/standards/DOC_SYNC_CHECKLIST.md` | 同步时机、更新内容 |
| 项目管理规范总览 | `docs/project-management/README.md` | 项目管理文档索引 |

### 六、知识库内容（Knowledge — 学什么）

| 文档 | 路径 | 用途 |
|------|------|------|
| 做题思路解析 | `knowledge-base/organized-content/做题思路解析.md` | 通用做题方法论（面向学习者） |
| 各章节知识拆解 | `knowledge-base/organized-content/<章节>/知识拆解.md` | 知识点整理 |
| 各章节考试指导 | `knowledge-base/organized-content/<章节>/考试指导.md` | 考点、易错点、记忆口诀 |
| 原始素材 | `knowledge-base/source-materials/<章节>/` | 做题记录、用户笔记、解析 |

---

## 文档维护规则

1. **新增文档时**：必须在本文档对应分类中添加条目，确保可发现
2. **删除文档时**：必须从本文档中移除条目，并检查是否有其他文档引用它
3. **文档移动/重命名时**：必须更新本文档和所有引用该文档的链接
4. **定期检查**：每次大阶段完成后，检查本文档与实际文件是否一致

---

## 文档优化记录

### 2026-08-29 文档治理优化

**新增文档**：
- `docs/REQUIREMENTS.md` — 项目需求文档
- `CHANGELOG.md` — 变更日志
- `CONTRIBUTING.md` — 贡献指南
- `LICENSE` — MIT协议
- `.github/ISSUE_TEMPLATE/` — Issue模板（bug_report、feature_request、documentation_issue）
- `.github/PULL_REQUEST_TEMPLATE.md` — PR模板

**合并文档**：
- `docs/knowledge-base/methodology/交互优化指南.md` → 合并到 `docs/development/guides/exam-workflow.md`（v4 JavaScript方法、检查清单、试卷统计）
- `docs/knowledge-base/methodology/做题流程与方法论.md` → 技术操作部分已在 `exam-workflow.md`，删除重复文档

**移动文档**：
- `docs/project-management/NAMING_CONVENTION.md` → `docs/project-management/standards/NAMING_CONVENTION.md`
- `docs/project-management/DOC_SYNC_CHECKLIST.md` → `docs/project-management/standards/DOC_SYNC_CHECKLIST.md`

**简化文档**：
- `docs/development/README.md` — 简化为快速索引，引用本文档
- `docs/project-management/README.md` — 简化为快速索引，引用本文档

**明确边界**：
- `AGENTS.md` — 添加文档边界说明（AI操作手册，不包含项目介绍、流程、需求）
- `README.md` — 添加文档边界说明（项目介绍，不包含AI规则、流程、需求）
- `docs/WORKFLOW.md` — 添加文档边界说明（操作流程，不包含项目介绍、AI规则、需求）

---

*本文档是项目的"文档索引"，所有新增/删除/移动文档时必须同步更新。*
