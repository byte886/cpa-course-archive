# Playwright CLI 使用指南

> 本文档记录 Playwright CLI 的正确用法、常见错误和最佳实践。
> 每次遇到新的问题或错误时，应及时更新本文档。

## 一、基本概念

### 1.1 连接方式

Playwright CLI 支持两种连接浏览器的方式：

1. **open 命令**：启动一个新的浏览器实例
   - 不支持 `--extension` 选项
   - 支持 `--browser`、`--headed`、`--persistent` 等选项
   - 适用于需要启动新浏览器的场景

2. **attach 命令**：连接到已运行的浏览器
   - 支持 `--extension` 选项（连接浏览器扩展）
   - 支持 `--cdp` 选项（连接 CDP 端点）
   - 支持 `--endpoint` 选项（连接 Playwright 服务器端点）
   - 适用于需要连接已运行浏览器的场景（如高顿教育网站已登录）

### 1.2 会话管理

- 使用 `-s=<session_name>` 指定会话名称
- 高顿教育项目使用会话名 `ga`
- 连接后，所有命令都需要指定会话名：`playwright-cli -s=ga <command>`

## 二、正确的命令用法

### 2.1 连接浏览器（高顿教育项目）

**正确用法**：
```bash
# 使用 attach 命令连接 Chrome 浏览器扩展
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach --extension=chrome
```

**常见错误**：
```bash
# ❌ 错误：open 命令不支持 --extension 选项
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga open --extension=chrome

# ❌ 错误：缺少 --extension 选项
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach
```

### 2.2 导航到 URL

**正确用法**：
```bash
# 使用 goto 命令导航到 URL
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga goto "https://glivepro.gaodun.com/course/42660/class-schedule"
```

**常见错误**：
```bash
# ❌ 错误：没有 navigate 命令，应该用 goto
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga navigate "https://..."

# ❌ 错误：URL 没有加引号（包含特殊字符时会出错）
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga goto https://glivepro.gaodun.com/course/42660/class-schedule
```

### 2.3 标签页管理

**正确用法**：
```bash
# 列出所有标签页
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga tab-list

# 创建新标签页
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga tab-new "https://..."

# 选择标签页（索引从 0 开始）
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga tab-select 1

# 关闭标签页
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga tab-close 2
```

**最佳实践**：
- 操作前先执行 `tab-list` 查看所有标签页
- 从后往前关闭多余页面（避免索引变化导致关错）
- 只保留当前工作页，如需参考文档可额外保留 1 个飞书文档页

### 2.4 页面操作

**正确用法**：
```bash
# 获取页面快照（获取元素 ref）
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga snapshot --depth=8

# 点击元素
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga click e123

# 截图
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga screenshot --filename=/tmp/page.png

# 执行 JavaScript
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga eval "window.location.href"

# 重新加载页面
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga reload
```

### 2.5 断开连接

**正确用法**：
```bash
# 断开连接（不关闭浏览器）
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga detach

# 关闭浏览器
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga close
```

## 三、常见错误与解决方案

### 3.1 错误：open 命令不支持 --extension 选项

**错误信息**：
```
Unknown option: --extension
```

**原因**：`open` 命令用于启动新浏览器，不支持 `--extension` 选项。`--extension` 选项只在 `attach` 命令中可用。

**解决方案**：使用 `attach` 命令代替 `open` 命令：
```bash
# ✅ 正确
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach --extension=chrome
```

### 3.2 错误：没有 navigate 命令

**错误信息**：
```
Unknown command: navigate
```

**原因**：Playwright CLI 没有 `navigate` 命令，导航 URL 应该使用 `goto` 命令。

**解决方案**：使用 `goto` 命令：
```bash
# ✅ 正确
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga goto "https://..."
```

### 3.3 错误：浏览器会话未打开

**错误信息**：
```
The browser 'ga' is not open, please run open first
```

**原因**：会话 `ga` 未连接到浏览器，需要先执行 `attach` 命令。

**解决方案**：先连接浏览器，再执行其他命令：
```bash
# 1. 连接浏览器
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach --extension=chrome

# 2. 等待 2 秒
sleep 2

# 3. 执行其他命令
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga tab-list
```

### 3.4 错误：元素 ref 失效

**错误信息**：
```
Element not found
```

**原因**：页面变化后，之前获取的元素 ref 可能失效，需要重新获取快照。

**解决方案**：每次页面变化后，重新执行 `snapshot` 获取最新的元素 ref。

### 3.5 错误：CDP 不可用

**错误信息**：
```
Not allowed
```

**原因**：Extension 模式下 CDP 不可用，只能用 Playwright CLI 命令。

**解决方案**：使用 Playwright CLI 命令，不要尝试使用 CDP。

## 四、最佳实践

### 4.1 命令执行前检查

每次执行 Playwright CLI 命令前，先检查：
1. 浏览器会话是否已连接（`tab-list`）
2. 当前标签页是否正确（`tab-list`）
3. 命令名称是否正确（`goto` 不是 `navigate`，`attach` 不是 `open --extension`）

### 4.2 页面加载等待

导航到新页面后，等待页面加载完成：
```bash
# 导航到 URL
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga goto "https://..."

# 等待 3 秒页面加载
sleep 3

# 检查当前 URL
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga eval "window.location.href"
```

### 4.3 环境变量设置

为了避免每次都输入 token，可以设置环境变量：
```bash
# 设置环境变量（仅当前会话有效）
export PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token>

# 之后可以直接使用
npx playwright cli -s=ga attach --extension=chrome
```

### 4.4 命令封装

对于常用的命令组合，可以封装成脚本：
```bash
#!/bin/bash
# scripts/playwright-connect.sh
# 连接到高顿教育浏览器会话

export PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token>

# 连接浏览器
npx playwright cli -s=ga attach --extension=chrome

# 等待连接
sleep 2

# 列出标签页
npx playwright cli -s=ga tab-list
```

## 五、命令速查表

| 操作 | 正确命令 | 常见错误 |
|------|----------|----------|
| 连接浏览器扩展 | `attach --extension=chrome` | `open --extension=chrome` ❌ |
| 导航到 URL | `goto <url>` | `navigate <url>` ❌ |
| 列出标签页 | `tab-list` | - |
| 创建新标签页 | `tab-new <url>` | - |
| 选择标签页 | `tab-select <index>` | - |
| 关闭标签页 | `tab-close <index>` | - |
| 获取页面快照 | `snapshot --depth=8` | - |
| 点击元素 | `click <ref>` | - |
| 截图 | `screenshot --filename=<path>` | - |
| 执行 JS | `eval <expression>` | - |
| 重新加载 | `reload` | - |
| 断开连接 | `detach` | - |
| 关闭浏览器 | `close` | - |

## 六、相关文档

- [video-processing.md](./video-processing.md) — 视频处理详细指南（包含 Playwright 捕获密钥的步骤）
- [exam-workflow.md](./exam-workflow.md) — 做题流程与交互规范（包含页面管理原则）
- [../WORKFLOW.md](../WORKFLOW.md) — 总体工作流
