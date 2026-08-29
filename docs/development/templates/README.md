# 模板目录（templates）

> **文档类型**：Reference（参考资料）
> **更新频率**：新增或变更模板时
> **维护者**：AI自动维护
> **读者**：AI代理（生成文档时参考模板）

本目录存放项目所有模板文件，统一管理，避免分散。

---

## 模板清单

| 模板文件 | 用途 | 适用场景 |
|---------|------|---------|
| `KNOWLEDGE_BASE_TEMPLATE.md` | 知识库内容模板 | 生成知识拆解和考试指导文档时 |
| `PARENT_NODE_TEMPLATE.md` | 知识库父节点模板 | 生成章节父节点页面（含子节点链接）时 |
| `REPORT_TEMPLATE.md` | 任务报告模板 | 生成任务完成报告时 |
| `VERIFICATION_TEMPLATE.md` | 通用验证报告模板 | 验证任何对象（视频、转写、OCR等）时 |
| `VERIFICATION_TEMPLATE_knowledge_base.md` | 知识库验证报告模板 | 验证飞书知识库页面导入质量时 |

---

## 模板使用原则

1. **生成文档前先读对应模板**：确保文档结构和格式统一
2. **模板变更时同步更新**：模板变更后，已生成的文档不需要强制更新，但新文档必须使用新模板
3. **通用模板 vs 专用模板**：
   - 通用验证模板适用于任何验证对象
   - 知识库验证模板专门用于知识库验证，有具体的8个验证项
   - 两者不合并，保持特异性
4. **模板只放本目录**：所有模板统一放在本目录，其他目录不放模板文件

---

## 模板分类

### 知识库模板（2个）
- `KNOWLEDGE_BASE_TEMPLATE.md`：知识拆解 + 考试指导
- `PARENT_NODE_TEMPLATE.md`：章节父节点（含子节点链接）

### 报告模板（1个）
- `REPORT_TEMPLATE.md`：任务完成报告

### 验证模板（2个）
- `VERIFICATION_TEMPLATE.md`：通用验证报告
- `VERIFICATION_TEMPLATE_knowledge_base.md`：知识库验证报告（专用）

---

## 相关文档

- 知识库组织规范：`docs/development/knowledge/knowledge-base-organization.md`
- 质量保证规范：`docs/project-management/standards/QUALITY_ASSURANCE.md`
- 报告目录：`project-management/task-reports/`（只放实际报告，不放模板）
