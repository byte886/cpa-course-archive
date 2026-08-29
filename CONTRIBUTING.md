# 贡献指南

> **文档类型**：Governance（治理规范）
> **更新频率**：贡献流程变更时
> **维护者**：AI自动维护
> **读者**：AI代理+人类贡献者

> 本文档说明如何为高顿课程知识库系统做出贡献。

---

## 项目简介

本项目旨在通过高顿教育平台的视频和考试，构建一个个人知识库系统，同时提供视频和文档的永久备份。

- **核心诉求**：通过高顿教育平台的视频和考试来完成一个个人知识库系统，同时提供视频和文档的永久备份
- **项目目标**：自动化采集课程内容，生成结构化知识库，支持做题验证和持续迭代

---

## 如何贡献

### 1. 报告问题

如果发现 Bug 或有功能建议，请通过 GitHub Issues 提交：

1. 检查是否已有相关 Issue
2. 使用 Issue 模板提交
3. 提供详细的复现步骤和环境信息

### 2. 提交代码

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交变更：`git commit -m 'feat: add your feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 创建 Pull Request

### 3. 文档贡献

文档和代码同样重要。如果发现文档不完善或有错误，欢迎提交 PR 改进：

- 工作流文档（`docs/WORKFLOW.md`）
- 开发文档（`docs/development/`）
- 项目管理规范（`docs/project-management/`）
- 知识库模板（`docs/development/templates/`）

---

## 开发规范

### 提交信息规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/v1.0.0/) 格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**：

| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | 缺陷修复 |
| docs | 文档变更 |
| style | 代码格式（不影响功能） |
| refactor | 重构（既不是新增功能也不是修复bug） |
| perf | 性能优化 |
| test | 测试相关 |
| chore | 构建过程或辅助工具的变动 |
| ci | CI配置相关 |

**示例**：

```
feat(video): 支持视频下载断点续传

- 添加下载状态记录文件
- 支持中断后从断点继续
- 更新工作流文档

Closes #123
```

### 分支策略

| 分支 | 说明 |
|------|------|
| main | 主分支，稳定版本 |
| feature/* | 特性分支 |
| fix/* | 修复分支 |
| docs/* | 文档分支 |

### 代码规范

- Python：遵循 PEP 8，使用类型注解
- Shell：遵循 Google Shell Style Guide
- JavaScript/Node.js：遵循 ESLint 推荐规则
- 所有脚本必须有注释说明用途、参数和示例

---

## 文档规范

### 文档类型

所有文档必须在开头标注类型：

| 类型 | 说明 | 示例 |
|------|------|------|
| Concept | 概念说明 — 是什么 | 项目介绍、需求文档 |
| Task | 操作指南 — 怎么做 | 工作流、工具使用 |
| Reference | 参考资料 — 查什么 | 模板、命名规范 |
| Active | 过程记录 — 做了什么 | 任务状态、问题跟踪 |
| Governance | 治理规范 — 规则 | AI操作手册、项目计划 |

### 文档维护规则

1. **新增文档**：必须在 `docs/DOCUMENTATION_MAP.md` 中登记
2. **删除文档**：必须从文档地图中移除，并检查是否有其他文档引用
3. **移动/重命名**：必须更新文档地图和所有引用链接
4. **定期检查**：每阶段完成后，检查文档与实际是否一致

### 文档同步清单

每次需求/流程/结构变更时，按 `docs/project-management/standards/DOC_SYNC_CHECKLIST.md` 检查是否需要同步更新相关文档。

---

## 前置条件

### 环境要求

- macOS 12+（项目主要在 macOS 上开发和运行）
- Node.js 18+
- Python 3.10+
- ffmpeg（视频处理）
- Chrome 浏览器（Playwright 自动化）

### 工具安装

```bash
# 安装 Node.js 依赖
npm install

# 安装 Python 依赖（音频转写）
cd transcription
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 安装 pre-commit hook
pre-commit install
```

---

## 测试

### 测试驱动原则

每个新功能/新流程先做单样本测试，验证通过后再批量执行。

### 测试计划

每个测试任务创建 `project-management/test-plans/TEST_PLAN_*.md`，包含：
- 测试目标
- 测试范围
- 测试步骤与状态
- 发现的问题（小问题/大问题）
- 测试通过标准
- 测试结果记录

---

## 行为准则

本项目采用 [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) 行为准则。

参与项目即表示您同意遵守以下原则：

- 尊重不同的观点和经验
- 接受建设性的批评
- 关注对社区最有利的事情
- 对其他社区成员表示同理心

---

## 获取帮助

- 阅读项目文档：`docs/DOCUMENTATION_MAP.md`
- 查看常见问题：项目各文档中的 FAQ 部分
- 提交 Issue：GitHub Issues
- 查看决策记录：`docs/project-management/decisions/ADR-*.md`

---

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。
