# 开发文档索引

> **文档类型**：Reference（参考资料 — 文档索引）
> **更新频率**：文档结构变更时
> **维护者**：AI自动维护
> **读者**：AI代理

> 本文档是开发文档的快速索引。**完整的项目文档地图请参考 [DOCUMENTATION_MAP.md](../DOCUMENTATION_MAP.md)**。

---

## 目录结构

```
docs/development/
├── README.md                    # 本文档（索引）
├── api/                         # 接口与外部服务
│   ├── feishu-api.md            # 飞书API使用注意事项
│   ├── netdisk-setup.md         # 百度网盘集成：应用创建、API配置、上传脚本
│   └── encryption.md            # 加密凭证：Token加密存储与使用
├── guides/                      # 详细操作指南与规范
│   ├── AGENTS_MD_BEST_PRACTICES.md  # AGENTS.md写作最佳实践
│   ├── CODE_STYLE.md            # 编码规范
│   ├── exam-workflow.md         # 做题流程与交互规范（含交互优化、检查清单）
│   ├── interaction-workflow.md  # 通用交互流程与优化规范（所有Web场景）
│   └── git-workflow.md          # GitHub工作流：SSH配置、代理设置、常见问题
├── tools/                       # 工具使用指南
│   ├── playwright-cli-guide.md  # Playwright CLI使用指南
│   ├── video-processing.md      # 视频处理详细指南（下载/解密/压缩/验证）
│   ├── transcription.md         # 音频转文字：FunASR环境配置、性能数据
│   ├── ocr.md                   # OCR文字提取：macOS Vision框架、PDF转图片
│   └── document-download.md     # 文档下载：CDN直链获取、curl后台下载
├── knowledge/                   # 知识库管理
│   ├── knowledge-base-organization.md  # 知识库组织规范（AI友好）
│   └── knowledge-base-sources.md       # 知识库来源清单与整理流程
└── templates/                   # 模板
    ├── KNOWLEDGE_BASE_TEMPLATE.md  # 知识库内容模板（知识拆解+考试指导）
    ├── PARENT_NODE_TEMPLATE.md     # 知识库父节点内容模板
    ├── REPORT_TEMPLATE.md          # 任务报告模板
    ├── VERIFICATION_TEMPLATE.md    # 通用验证报告模板
    └── VERIFICATION_TEMPLATE_knowledge_base.md  # 知识库验证报告模板
```

---

## 技术栈

| 领域 | 技术/工具 |
|------|-----------|
| 视频下载 | Playwright + Node.js（HLS AES-128解密） |
| 视频压缩 | ffmpeg（H.265 CRF30） |
| 音频转文字 | FunASR SenseVoiceSmall（开源本地） |
| OCR | macOS Vision框架（系统原生）+ AI视觉补充 |
| 网盘 | 百度网盘开放平台API |
| 知识库 | 飞书知识库（Lark Wiki） |
| 浏览器自动化 | Playwright CLI（Extension模式附加到已登录Chrome） |

---

## 脚本位置

> 所有脚本统一放在 `scripts/` 目录，详细说明见 [scripts/README.md](../../scripts/README.md)

---

## 维护规则

1. **新增开发文档时**：按主题放入对应子目录（api/workflow/tools/knowledge），不要平铺在development/根目录
2. **新增子目录时**：必须在本文档中更新目录结构和文档列表
3. **文档移动/重命名时**：必须更新本文档和所有引用该文档的链接
4. **定期检查**：每次大阶段完成后，检查本文档与实际文件是否一致

---

**完整文档地图**：[DOCUMENTATION_MAP.md](../DOCUMENTATION_MAP.md)
