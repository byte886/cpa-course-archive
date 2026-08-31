# 变更日志

> **文档类型**：Active（过程记录）
> **更新频率**：每次重要变更后
> **维护者**：AI自动维护
> **读者**：AI代理+人类

> 本文档记录项目的所有重要变更，遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 格式。
> 版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

---

## [未发布]

### 新增
- 创建项目需求文档 `docs/REQUIREMENTS.md`，梳理核心诉求、功能需求、非功能需求、特殊规则和验收标准
- 创建标准开源文档：CHANGELOG.md、CONTRIBUTING.md、LICENSE、.github/模板
- 文档治理优化：合并重叠文档、统一文档结构、明确文档边界

### 变更
- 项目重命名：`cpa-course-archive` → `gaodun-course-knowledge-base`，本地目录 `gaodun_downloads` → `gaodun-course-knowledge-base`，标题"高顿 CPA 课程智能归档项目" → "高顿课程知识库系统"（百度网盘应用名称保持不变）
- 文档结构优化：将 project-management/ 根目录的规范文档移到 standards/ 子目录
- 合并做题交互相关文档（交互优化指南、exam-workflow、interaction-workflow 中的做题部分）
- 合并做题方法论文档（做题流程与方法论、做题思路解析）
- 状态查询协议新增 Q7「项目维护检查（执行型）」：补标准话术、模糊表达映射与7步执行流程，明确区分 Q3（只问有哪些维护）与 Q7（实际动手检查/修复/出报告）；README 精简话术表、PROJECT_STRUCTURE_MAINTENANCE 触发机制同步
- 02讲目录级联改名：本地+百度网盘 `02_消费税法（1）`→`02_税法全面精讲02-消费税法（1）`（网盘走 filemanager rename、不重传文件，内容完整）；飞书经核实为"文件系统全名 / 飞书简短标题"双轨制，02与01同级一致、保持"02消费税法（1）"；NAMING_CONVENTION 历史遗留小节重写为双轨制命名现状，BATCH 命名问题销项，结构脚本4目录0问题
- 文档类型词表统一为7类权威封闭词表（Task/Concept/Reference/Governance/Active/Knowledge/Template，新增 Template、取消自造的 Guide）：DOCUMENTATION_GUIDE 3.1 定词表并由 pre-commit 白名单强校验；6个 `*_TEMPLATE.md` 统一为 Template、multi-role-collaboration 由 Guide 归为 Governance

### 修复
- 2026-08-30 项目及文档整理：修复8个文档共14处相对路径断链（文档移入 development 子目录后未同步的层级引用），涉及 task-reports/README、REQUIREMENTS、WORKFLOW、document-download、playwright-cli-guide、knowledge-base-organization、netdisk-setup
- git-workflow 中3处当前可执行命令的旧仓库名 `cpa-course-archive` 更新为 `gaodun-course-knowledge-base`（历史叙述与ADR中的旧名保留）
- DOCUMENTATION_MAP 补登4个遗漏文档：DIRECTORY_STRUCTURE、SYSTEM_REQUIREMENTS、EXAM_RECORD_TEMPLATE、任务交接文档，并补充章节本地验证/同步报告说明
- 统一进度口径为 3/39、剩余36讲；修正 TASK_STATUS 5.9 文档类型标注统计（95个仓库文档中76个标注、19个按规范豁免）与交接文档"93个文档/剩余35讲"等过时数字
- 2026-08-31 Q7维护检查：补全 DIRECTORY_STRUCTURE 详细目录树漏列的4个文件（guides 3、templates 1）；统一2处旧角色名残留（交接文档"开发人员"→开发工程师、multi-role 协作角色"知识整理师"→产品经理）；新增0831健康度检查报告
- pre-commit 新增第5节自动校验：暂存 .md 的相对链接有效性检查（断链硬阻止，跳过围栏/行内代码/外链/锚点）与文档类型词白名单校验；git-workflow 9.2 检查项表同步；已用"故意制造断链+非法类型词"负向用例与空暂存正向用例双向自检

---

## [0.1.0] - 2026-08-28

### 新增
- 项目初始化：创建 GitHub 公有仓库 `cpa-course-archive`
- 核心功能：视频下载（HLS AES-128解密）、视频压缩（H.265 CRF30）、音频转写（FunASR）、OCR（macOS Vision）
- 知识库系统：飞书知识库集成，知识拆解与考试指导分离，两阶段生成
- 做题验证：自动化做题脚本，错题反馈与知识库补充
- 百度网盘集成：API上传，目录镜像
- 项目管理：任务状态跟踪、问题跟踪、测试计划、决策记录（ADR）
- 文档体系：工作流、开发文档、项目管理规范、知识库模板

### 技术栈
- 浏览器自动化：Playwright CLI（Extension模式）
- 视频处理：ffmpeg（H.265）
- 音频转写：FunASR SenseVoiceSmall
- OCR：macOS Vision框架
- 网盘：百度网盘开放平台API
- 知识库：飞书知识库（Lark Wiki）
- 版本控制：Git + GitHub（pre-commit hook）

---

## 版本说明

| 版本类型 | 说明 |
|----------|------|
| 主版本号 | 不兼容的 API 变更 |
| 次版本号 | 向下兼容的功能性新增 |
| 修订号 | 向下兼容的问题修正 |

### 变更类型

- **Added** — 新功能
- **Changed** — 对现有功能的变更
- **Deprecated** — 即将废弃的功能
- **Removed** — 已废弃的功能
- **Fixed** — 缺陷修复
- **Security** — 安全相关修复
