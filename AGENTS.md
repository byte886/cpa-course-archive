# 项目全局执行规则

## ⚠️ 最高优先级：执行前必读文档

**执行任何任务前，必须按以下顺序查阅文档，未查阅不得开始执行：**

1. **先读 `README.md`** — 了解项目概览、存储分工、核心原则
2. **再读 `docs/WORKFLOW.md` 对应环节** — 找到当前任务所属的流程环节，阅读详细步骤
3. **按 WORKFLOW 中的「参考文档」链接查阅专项文档** — 如交互优化指南、压缩参数说明等
4. **最后检查 `docs/project-management/active/TASK_STATUS.md`** — 确认当前任务状态和前置依赖

### 为什么必须这样做

- 本项目流程复杂，涉及视频下载、压缩、转文字、知识库、做题验证等多个环节
- 每个环节都有专项文档记录了踩过的坑和优化方案
- 不查阅文档直接执行，大概率会重复犯之前已经解决过的错误
- 文档是项目的"集体记忆"，必须依赖文档而不是对话记忆

### 违反规则的后果

如果发现执行时没有查阅相关文档导致出错，必须：
1. 立即停止当前操作
2. 查阅相关文档
3. 重新执行
4. 将本次教训补充到对应文档中

---

## ⚠️ 任务开始前强制检查清单（所有浏览器操作任务）

**开始任何需要浏览器操作的任务前，必须按以下清单逐项检查，未完成不得开始任务：**

### 检查清单

| 序号 | 检查项 | 检查方法 | 处理方式 |
|------|--------|----------|----------|
| 1 | **关闭无关tab页** | `npx playwright cli -s=ga tab-list` | 超过2个tab时，关闭除工作页面外的所有页面 |
| 2 | **检查Playwright连接状态** | `npx playwright cli -s=ga tab-list` | 如果报错"The browser is not open"，执行连接流程 |
| 3 | **连接失败自动刷新Token** | 连接超时或报错 | 按 [playwright-cli-guide.md 第4节](docs/development/playwright-cli-guide.md) "Token自动刷新流程"自动刷新，**禁止直接要求用户手动操作** |
| 4 | **检查当前页面是否正确** | `npx playwright cli -s=ga eval "() => window.location.href"` | 如果不是目标页面，导航到正确URL |
| 5 | **检查任务前置依赖** | 查看 `docs/project-management/active/TASK_STATUS.md` | 确认前置任务已完成 |

### 执行方式

```bash
# 1. 检查tab列表
npx playwright cli -s=ga tab-list

# 2. 如果连接失败，自动刷新Token（参考文档，不要直接问用户）
# 3. 关闭无关tab
npx playwright cli -s=ga tab-close <index>

# 4. 确认当前页面
npx playwright cli -s=ga eval "() => window.location.href"
```

### 违反规则的后果

如果发现开始任务时没有执行检查清单导致出错（如页面混乱、连接失败、Token过期等），必须：
1. 立即停止当前操作
2. 执行检查清单
3. 重新开始任务
4. 将本次教训补充到对应文档中

---

## ⚠️ 异常处理流程（任何操作失败时）

**任何操作失败时，必须按以下流程处理，禁止直接要求用户手动操作：**

### 处理流程

1. **先检查文档中是否有解决方案**：
   - 用 `grep -rn "关键词" docs/` 搜索相关文档
   - 查看对应专项文档的"常见问题"、"故障排除"、"解决方案"章节
   
2. **按文档中的解决方案尝试自动修复**：
   - 如果文档中有明确的解决方案，立即按文档执行
   - 例如：连接失败 → 自动刷新Token；命令卡住 → 按分级处理流程恢复
   
3. **如果文档中没有解决方案**：
   - 先尝试通用的故障排除方法（如重启进程、清理缓存、检查网络）
   - 仍然无法解决时，再请求用户帮助，并说明已尝试的方法

### 常见异常的自动处理

| 异常情况 | 自动处理方式 | 参考文档 |
|----------|-------------|----------|
| Playwright连接失败 | 自动刷新Token后重连 | playwright-cli-guide.md 第4节 |
| 命令卡住/超时 | 按分级处理流程：检查session→刷新页面→重连 | interaction-workflow.md 第4.5节 |
| 页面元素找不到 | 等待页面加载→刷新页面→检查选择器 | interaction-workflow.md |
| 脚本执行报错 | 查看错误日志→检查依赖→按文档修复 | 对应脚本的README |

### 违反规则的后果

如果发现操作失败时没有先检查文档就直接要求用户手动操作，必须：
1. 立即停止
2. 检查文档中的解决方案
3. 尝试自动修复
4. 将本次教训补充到对应文档中

---

## 文档快速入口

按任务类型查找文档：

| 任务类型 | 先看 | 再看 |
|----------|------|------|
| 视频下载/压缩 | `docs/WORKFLOW.md` 第2节 | `docs/development/video-processing.md` |
| 文档下载 | `docs/WORKFLOW.md` 第3节 | - |
| 百度网盘同步 | `docs/WORKFLOW.md` 第4节 | `docs/development/netdisk-setup.md` |
| 视频转文字 | `docs/WORKFLOW.md` 第5节 | `docs/development/transcription.md` |
| 知识库生成 | `docs/WORKFLOW.md` 第6节 | `docs/development/knowledge-base-organization.md`、`docs/development/knowledge-base-sources.md` |
| **做题验证** | `docs/WORKFLOW.md` 第7节 | **`docs/knowledge-base/methodology/交互优化指南.md`** |
| 任务报告 | `docs/WORKFLOW.md` 第8节 | `docs/project-management/README.md` |
| Git操作 | `docs/development/git-workflow.md` | - |
| 项目维护 | `docs/project-management/standards/PROJECT_MAINTENANCE.md` | - |

---

## 其他全局规则

### 问题驱动更新（强制）

发现任何问题（文件位置不对、脚本有bug、流程有缺陷、文档缺失等）时，必须立即评估是否需要更新文档或自动化检查，评估后必须执行，不能只发现问题不更新。

### 小问题顺手修复，大问题讨论处理

- **小问题**（如文档链接错误、文件名不对、简单脚本bug）：顺手修复，并记录到任务报告
- **大问题**（如流程变更、架构调整、新增功能）：先和用户讨论，确认方案后再执行

### 定期检查项目结构

每次开始新任务前、完成大任务后，必须检查项目结构是否合理，发现问题主动梳理调整。

### 写文档前必须检查文档组织（强制，即时触发）

**遇到问题需要写文档、更新文档或新增内容时，必须先检查项目文档组织和分工，禁止直接写到任意文档中。**

**检查流程（必须执行）**：
1. **查看文档目录结构**：`ls -la docs/`、`ls -la docs/development/`、`ls -la docs/project-management/`
2. **查找相关文档**：用 `grep -r "关键词" docs/` 查找是否已有相关内容的文档
3. **确认文档分工**：
   - `docs/WORKFLOW.md` — 主工作流（只放流程概览和链接，不放详细内容）
   - `docs/development/*.md` — 专项技术文档（如playwright-cli-guide、interaction-workflow、transcription等）
   - `docs/project-management/*.md` — 项目管理文档（如DOC_SYNC_CHECKLIST、standards等）
   - `docs/knowledge-base/*.md` — 知识库相关文档
4. **选择正确的文档**：根据内容性质选择对应的专项文档，WORKFLOW.md只放摘要和链接
5. **确保文档关联**：新增或更新内容后，确保相关文档之间有链接，不会找不到

**常见错误（禁止）**：
- ❌ 直接把详细技术内容写到WORKFLOW.md中
- ❌ 不检查是否已有相关文档就新建文档
- ❌ 把交互规范写到技术文档中，或把技术规范写到交互文档中
- ❌ 新增内容后不更新相关文档的链接

**违反规则的后果**：
如果发现写文档时没有先检查文档组织导致内容放错位置，必须：
1. 立即停止当前操作
2. 检查文档组织，找到正确的文档位置
3. 将内容移到正确的文档中
4. 在原文档中只保留摘要和链接
5. 将本次教训补充到本规则中

### 文档同步规则（强制）

每次完成阶段性任务、生成新文档、或变化项目结构时，必须按 [docs/project-management/DOC_SYNC_CHECKLIST.md](docs/project-management/DOC_SYNC_CHECKLIST.md) 检查并同步相关文档。

**同步时机**：
- 完成单个讲座流程后
- 完成所有试卷后
- 发现问题并解决后
- 项目结构调整后
- 大阶段完成后

**核心原则**：本地文档为主，飞书表格为辅；问题驱动更新，发现问题立即评估是否需要更新文档。

### 存储分工

- **GitHub 仓库**：只放代码和文档，不放生成结果
- **本地 `~/Desktop/高顿/`**：视频文件、讲义文档、文字稿（生成结果）
- **百度网盘**：与本地完全镜像
- **飞书知识库**：知识梳理内容
- **飞书文档**：任务报告

### 清理原则

- 测试文件、临时日志、残留目录及时清理
- 完成任务后检查是否有中间产物需要清理
- 不要在项目根目录散落临时文件
