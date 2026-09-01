# 报告目录

> **文档类型**：Reference（参考资料）
> **更新频率**：新增报告时
> **维护者**：AI自动维护
> **读者**：AI代理+人类

本目录存放项目中所有**实际报告**，包括任务报告和验证报告。

> ⚠️ **模板已迁移**：所有模板文件已统一移到 [`docs/development/templates/`](../../docs/development/templates/) 目录，本目录只放实际报告。

---

## 文档清单

> 当前暂无实际报告（历史报告可经 git 查阅）。新报告按下方模板生成；针对具体课程的报告优先放在对应课程目录，本目录只放跨课程的通用报告。

---

## 报告类型

### 1. 任务报告

每次批量任务完成后生成，记录：
- 处理了哪些讲座/课程
- 视频/文档下载状态和文件大小
- 压缩参数和最终体积
- 遇到的问题和解决方案
- 知识库更新情况
- 做题结果
- 缺陷统计

**模板**：[`docs/development/templates/REPORT_TEMPLATE.md`](../../docs/development/templates/REPORT_TEMPLATE.md)

### 2. 验证报告

每个产出物（知识梳理文档、视频压缩、文档上传等）验证后生成，记录：
- 验证对象和时间
- 验证清单和结果
- 发现的问题
- 验证结论
- 后续建议

**模板**：
- 通用验证：[`docs/development/templates/VERIFICATION_TEMPLATE.md`](../../docs/development/templates/VERIFICATION_TEMPLATE.md)
- 知识库验证：[`docs/development/templates/VERIFICATION_TEMPLATE_KNOWLEDGE_BASE.md`](../../docs/development/templates/VERIFICATION_TEMPLATE_KNOWLEDGE_BASE.md)

**规范**：[`docs/project-management/standards/QUALITY_ASSURANCE.md`](../../docs/project-management/standards/QUALITY_ASSURANCE.md)

---

## 命名规范

| 报告类型 | 命名格式 | 示例 | 适用场景 |
|----------|----------|------|---------|
| 任务报告 | `任务报告_{对象}_{日期}.md` | `任务报告_税法01批量压缩_2026-08-29.md` | 批量任务执行报告 |
| 综合验证报告 | `VERIFICATION.md` | `01_税法全面精讲01-税法总论/VERIFICATION.md` | 课程目录下的综合验证（目录本身已说明课程） |
| 专项验证报告 | `验证报告_{对象}_{范围}.md` | `验证报告_税法总论_分章真题测.md` | 知识库质量验证、做题验证等专项 |
| 同步报告 | `同步报告_{对象}_{日期}.md` | `同步报告_税法总论_2026-08-28.md` | 飞书知识库同步报告 |

> **注意**：针对具体课程的任务报告和验证报告，优先放在**对应课程目录下**（和被验证对象在一起），本目录只放跨课程的通用报告。

---

## 归档规则

- 所有报告随项目代码一起提交到GitHub
- 报告完成后在任务状态文档中标记
- 定期回顾报告，统计常见问题，优化流程
- 模板变更时，已生成的报告不需要强制更新，但新报告必须使用新模板
