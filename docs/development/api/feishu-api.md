# 飞书 API 使用注意事项

> **文档类型**：Reference（参考资料）
> **更新频率**：API变更时
> **维护者**：AI自动维护
> **读者**：AI代理

本文档记录使用 `lark-cli` 操作飞书 API 时遇到的技术问题、解决方案和最佳实践。

---

## 一、Wiki 节点操作

### 1.1 删除节点：必须用 URL 方式，不能用 raw token

**问题**：使用 `lark-cli wiki +node-delete` 删除节点时，如果用 raw token + `--space-id` + `--obj-type docx`，会报 `node not found`（错误码 131005）。

**错误示例**：
```bash
# ❌ 会报 node not found (code 131005)
lark-cli wiki +node-delete \
  --space-id 7678261729456852192 \
  --node-token J9g6wQ14wilTqHktEH1c5TkUn2f \
  --obj-type docx \
  --yes
```

**正确示例**：
```bash
# ✅ 用 URL 方式，自动解析 space_id 和 obj_type
lark-cli wiki +node-delete \
  --node-token "https://zcnjheoajxng.feishu.cn/wiki/J9g6wQ14wilTqHktEH1c5TkUn2f" \
  --yes
```

**原因**：URL 方式会自动调用 `get_node` 解析正确的 `space_id` 和 `obj_type`，而 raw token 方式可能因为参数不匹配导致找不到节点。

**最佳实践**：所有 wiki 节点操作（删除、获取信息等）优先使用 URL 方式传入 `--node-token`。

---

### 1.2 node-list 参数名

**正确参数名**：
- `--space-id`（不是 `--space`）
- `--parent-node-token`（不是 `--parent-node`）

**示例**：
```bash
lark-cli wiki +node-list \
  --space-id 7678261729456852192 \
  --parent-node-token UM6bwW23tiYkCVk3nXtc3TpBnGe
```

---

### 1.3 node-get 的 obj-type 不接受 "wiki"

**问题**：`lark-cli wiki +node-get --obj-type wiki` 会报错，因为 `--obj-type` 只接受 `doc, docx, sheet, bitable, mindnote, slides, file`。

**正确方式**：用 URL 方式，自动推断 obj_type：
```bash
lark-cli wiki +node-get \
  --node-token "https://zcnjheoajxng.feishu.cn/wiki/J9g6wQ14wilTqHktEH1c5TkUn2f"
```

---

## 二、文档内容操作

### 2.1 docs +update 的 --content 不接受绝对路径

**问题**：`lark-cli docs +update --content /tmp/file.md` 会报错，因为 `--content` 只接受相对路径（当前目录内）或 stdin。

**错误示例**：
```bash
# ❌ 报错：invalid file path, must be a relative path within the current directory
lark-cli docs +update --doc <token> --command overwrite --content @/tmp/file.md
```

**正确方式1**：用相对路径
```bash
# ✅ 文件放在当前目录下
lark-cli docs +update --doc <token> --command overwrite --content @./file.md
```

**正确方式2**：用 stdin（推荐，避免临时文件）
```bash
# ✅ 通过管道传递内容
cat << 'EOF' | lark-cli docs +update --doc <token> --command overwrite --doc-format markdown --content -
# 文档标题
内容...
EOF
```

---

### 2.2 Markdown 格式更新

使用 `--doc-format markdown` 可以用 Markdown 格式更新文档，支持标准 Markdown 语法：
- 标题：`#`, `##`, `###`
- 链接：`[文本](URL)`
- 引用：`> 引用内容`
- 列表：`- 项目` 或 `1. 项目`
- 表格：标准 Markdown 表格
- 分割线：`---`

**示例**：
```bash
cat << 'EOF' | lark-cli docs +update \
  --doc EV7vdI57wopS2ixYUbFcQPKmnwQ \
  --command overwrite \
  --doc-format markdown \
  --content -
> 课程：2026 CPA 税法-全面精讲 | 主讲：蔡俊峻老师

## 本章内容

### 知识本身
[第一章 税法总论](https://...)
EOF
```

---

## 三、权限设置

### 3.1 文档对外分享：API 可能受组织策略限制

**问题**：使用 `lark-cli drive permission.public patch` 设置文档为"互联网获得链接的人可阅读"时，可能报 `Permission denied`（错误码 1063002）。

**原因**：组织管理员设置了安全策略，禁止通过 API 将文档分享到组织外。

**解决方案**：通过飞书网页界面手动设置分享权限（界面操作不受 API 权限限制）。

**界面操作流程**：
1. 打开文档
2. 点击右上角「Share」按钮
3. 点击「组织名称」下拉菜单
4. 选择「Anyone with the link」
5. 选择「Current page and sub-pages」（应用到子页面）
6. 点击「Confirm」确认法律责任提示

---

## 四、通用最佳实践

### 4.1 优先使用 URL 方式传入 token

所有需要 token 的操作（wiki 节点、文档等），优先使用完整 URL 传入，让 CLI 自动解析 token 类型和相关参数：

```bash
# ✅ 推荐：URL 方式，自动解析
lark-cli wiki +node-get --node-token "https://zcnjheoajxng.feishu.cn/wiki/<token>"
lark-cli docs +fetch --doc "https://zcnjheoajxng.feishu.cn/docx/<token>"
```

### 4.2 高风险操作需要 --yes

删除节点、删除文档等高风险写操作需要加 `--yes` 确认：
```bash
lark-cli wiki +node-delete --node-token "<URL>" --yes
```

### 4.3 输出可能被保存到文件

某些命令的输出（特别是 JSON 响应）可能被自动保存到 `download.txt` 文件，而不是直接输出到 stdout。需要读取该文件获取响应内容。

---

> 本文档记录飞书 API 使用中的技术问题和解决方案。遇到新问题时，按"问题→错误示例→正确示例→原因→最佳实践"的格式补充到本文档。
