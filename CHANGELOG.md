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

### 修复
- 2026-08-30 项目及文档整理：修复8个文档共14处相对路径断链（文档移入 development 子目录后未同步的层级引用），涉及 task-reports/README、REQUIREMENTS、WORKFLOW、document-download、playwright-cli-guide、knowledge-base-organization、netdisk-setup
- git-workflow 中3处当前可执行命令的旧仓库名 `cpa-course-archive` 更新为 `gaodun-course-knowledge-base`（历史叙述与ADR中的旧名保留）
- DOCUMENTATION_MAP 补登4个遗漏文档：DIRECTORY_STRUCTURE、SYSTEM_REQUIREMENTS、EXAM_RECORD_TEMPLATE、任务交接文档，并补充章节本地验证/同步报告说明
- 统一进度口径为 3/39、剩余36讲；修正 TASK_STATUS 5.9 文档类型标注统计（95个仓库文档中76个标注、19个按规范豁免）与交接文档"93个文档/剩余35讲"等过时数字

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
