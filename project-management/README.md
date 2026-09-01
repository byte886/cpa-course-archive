# 项目管理（动态内容）

> **文档类型**：Reference（参考资料）
> **更新频率**：目录结构变更时
> **维护者**：AI自动维护
> **读者**：AI代理+人类

本目录存放项目管理的**动态内容**，包括任务状态、问题跟踪、测试计划、任务报告、验证报告等。

> **与 docs/ 的区别**：
> - `docs/`：只放静态内容（方法论、流程、说明、规范、决策记录）
> - `project-management/`：放动态内容（任务状态、问题跟踪、测试计划、报告等）

---

## 目录结构

```
project-management/
├── active/                    # 活动状态（频繁更新）
│   ├── TASK_STATUS.md         # 任务状态（唯一任务状态来源）
│   ├── ISSUES.md              # 问题跟踪（唯一问题跟踪来源）
│   ├── BATCH_TASK_STATUS.md   # 批量任务状态
│   ├── COURSE_INDEX.md        # 课程索引
│   └── README.md
├── test-plans/                # 测试计划（按课程生成；当前暂无留存，历史见 git）
├── task-reports/              # 任务执行报告（按任务生成）
│   └── README.md
└── verification-reports/      # 质量验证报告（按验证生成，中文命名；当前暂无留存，历史报告可经 git 查阅）
```

---

## 各目录职责

| 目录 | 类型 | 更新频率 | 说明 |
|------|------|----------|------|
| **active/** | 动态 | 频繁更新 | 任务状态、问题跟踪、课程索引等实时状态 |
| **test-plans/** | 半动态 | 按课程生成 | 具体课程的测试计划，按课程新增 |
| **task-reports/** | 动态 | 按任务生成 | 任务执行完成报告，按任务新增 |
| **verification-reports/** | 动态 | 按验证生成 | 质量验证报告，按验证新增 |

---

## 与 docs/ 的职责边界

| 内容类型 | 存放位置 | 说明 |
|----------|----------|------|
| 方法论、流程、说明 | `docs/` | 静态内容，不频繁更新 |
| 标准规范 | `docs/project-management/standards/` | 静态规范 |
| 决策记录（ADR） | `docs/project-management/decisions/` | 半静态，只增不改 |
| 任务状态 | `project-management/active/` | 动态，频繁更新 |
| 问题跟踪 | `project-management/active/` | 动态，频繁更新 |
| 测试计划 | `project-management/test-plans/` | 半动态，按课程生成 |
| 任务报告 | `project-management/task-reports/` | 动态，按任务生成 |
| 验证报告 | `project-management/verification-reports/` | 动态，按验证生成 |

---

## 文件命名规范

| 目录 | 命名格式 | 示例 |
|------|----------|------|
| test-plans/ | `测试计划_{课程名}.md` | 当前暂无；模板 `TEST_PLAN_TEMPLATE.md` |
| task-reports/ | `任务报告_{序号}_{课程名}_{日期}.md` | 当前仅历史（见 git）；模板 `REPORT_TEMPLATE.md` |
| verification-reports/ | `验证报告_{对象}_{范围或日期}.md` | `验证报告_税法总论_分章真题测.md`（knowledge-base） |

---

**文档维护**：本目录结构变更时，必须更新本文档和 `docs/DIRECTORY_STRUCTURE.md`。
