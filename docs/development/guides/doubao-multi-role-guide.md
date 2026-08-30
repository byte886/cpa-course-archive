# 豆包多角色定制 - 操作指南与踩坑记录

## 概述

本文档记录豆包工作伙伴（多角色）定制过程中的操作方法、最佳实践和踩坑记录，用于后续配置其他角色时参考。

## 一、角色配置入口

### 1.1 访问方式

- **主入口**：豆包客户端 → 工作伙伴 → 选择角色 → 详情
- **网页版**：https://www.doubao.com/chat/buddy/buddies/{agent_id}
- **注意**：实际编辑器在跨域iframe中（aily.doubao.com），直接操作主页面无法访问编辑器

### 1.2 配置文件结构

每个角色包含以下配置文件（在"全部文件"侧边栏中）：
- `AGENTS.md` - 角色工作空间主配置（启动顺序、技能列表、执行门禁等）
- `IDENTITY.md` - 角色身份定义（角色名称、定位、核心能力）
- `SOUL.md` - 角色灵魂/价值观
- `USER.md` - 用户画像
- `skills/` - 角色专属技能目录

## 二、AGENTS.md 编辑方法（重点）

### 2.1 编辑器技术栈

- **编辑器**：CodeMirror 6
- **DOM结构**：`.cm-editor` > `.cm-content` > `.cm-line`
- **特殊点**：没有标准的textarea/input元素，使用CodeMirror内部状态管理

### 2.2 踩坑记录：内容粘贴被截断

#### 问题描述
使用Playwright操作AGENTS.md编辑器时，粘贴长内容（>2000字符）时被截断，只能粘贴部分内容。

#### 尝试过的失败方法
1. **系统剪贴板 + CMD+V**：浏览器无法访问系统剪贴板，粘贴无效
2. **`navigator.clipboard.writeText()`**：需要用户交互权限，且异步返回不稳定
3. **`document.execCommand('copy')`**：复制成功，但粘贴时内容被截断（约2300字符上限）
4. **`page.keyboard.type()`**：输入太慢（88行需要几分钟），且可能因超时被中断
5. **直接修改DOM**：CodeMirror不识别外部DOM修改，内容会被重置

#### 最终解决方案：ClipboardEvent 直接触发

**核心原理**：直接在编辑器DOM元素上dispatch一个`ClipboardEvent('paste')`事件，绕过系统剪贴板限制。

**操作步骤**：

1. **直接导航到iframe URL**（避免跨域）：
   ```bash
   npx playwright cli -s=doubao goto "https://aily.doubao.com/doubao/buddies/{agent_id}"
   ```

2. **分段传递长内容到浏览器**（base64编码，每块约500字符）：
   ```javascript
   // 初始化存储数组
   window.__paste_content_parts = [];
   
   // 每块内容用base64编码后传递
   const chunk = decodeURIComponent(escape(atob(b64_chunk)));
   window.__paste_content_parts.push(chunk);
   ```

3. **用ClipboardEvent直接粘贴**：
   ```javascript
   // 拼接所有内容块
   const fullContent = window.__paste_content_parts.join('');
   
   // 找到CodeMirror的content元素
   const cmContent = document.querySelector('.cm-content');
   
   // 先focus编辑器
   cmContent.focus();
   cmContent.click();
   
   // 创建DataTransfer对象
   const dt = new DataTransfer();
   dt.setData('text/plain', fullContent);
   
   // 创建ClipboardEvent
   const pasteEvent = new ClipboardEvent('paste', {
     bubbles: true,
     cancelable: true,
     clipboardData: dt
   });
   
   // 先全选（CMD+A），确保粘贴替换所有内容
   const selectAllEvent = new KeyboardEvent('keydown', {
     key: 'a', code: 'KeyA', keyCode: 65, which: 65,
     bubbles: true, cancelable: true,
     metaKey: true // Mac用metaKey，Windows用ctrlKey
   });
   cmContent.dispatchEvent(selectAllEvent);
   
   // 触发paste事件
   setTimeout(() => {
     cmContent.dispatchEvent(pasteEvent);
   }, 100);
   ```

4. **验证内容完整性**：
   ```javascript
   const cmContent = document.querySelector('.cm-content');
   console.log('Content length:', cmContent.textContent.length);
   ```

5. **点击保存按钮**：
   ```javascript
   // 找到右上角的"保存"按钮并点击
   const saveBtn = Array.from(document.querySelectorAll('*')).find(el => 
     el.textContent.trim() === '保存' && el.offsetParent !== null
   );
   saveBtn.click();
   ```

#### 完整Python脚本参考

```python
#!/usr/bin/env python3
import subprocess
import base64
import time

def run_eval(js_code, timeout=30):
    cmd = ['npx', 'playwright', 'cli', '-s=doubao', 'eval', js_code]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    return result.stdout + result.stderr

# 1. 读取文件内容
with open('AGENTS.md', 'r', encoding='utf-8') as f:
    content = f.read()

# 2. 分段传递到浏览器
run_eval("window.__paste_content_parts = [];")
chunk_size = 500
chunks = [content[i:i+chunk_size] for i in range(0, len(content), chunk_size)]
for chunk in chunks:
    b64 = base64.b64encode(chunk.encode('utf-8')).decode('ascii')
    run_eval(f"""
    const chunk = decodeURIComponent(escape(atob("{b64}")));
    window.__paste_content_parts.push(chunk);
    """)

# 3. 用ClipboardEvent粘贴
run_eval("""
const fullContent = window.__paste_content_parts.join('');
const cmContent = document.querySelector('.cm-content');
cmContent.focus();
cmContent.click();

const dt = new DataTransfer();
dt.setData('text/plain', fullContent);
const pasteEvent = new ClipboardEvent('paste', {
  bubbles: true, cancelable: true, clipboardData: dt
});

const selectAllEvent = new KeyboardEvent('keydown', {
  key: 'a', code: 'KeyA', keyCode: 65, which: 65,
  bubbles: true, cancelable: true, metaKey: true
});
cmContent.dispatchEvent(selectAllEvent);

setTimeout(() => cmContent.dispatchEvent(pasteEvent), 100);
""")

time.sleep(3)

# 4. 点击保存
run_eval("""
const saveBtn = Array.from(document.querySelectorAll('*')).find(el => 
  el.textContent.trim() === '保存' && el.offsetParent !== null
);
if (saveBtn) saveBtn.click();
""")
```

## 三、技能配置

### 3.1 技能添加方式

1. **市场添加**：角色详情 → 技能 → 添加技能 → 从市场选择
2. **自定义技能**：在`skills/`目录下创建技能文件夹，包含`SKILL.md`
3. **内置技能**：部分技能无法移除（如飞书卡片生成、用户工作画像等）

### 3.2 技能选择原则

- **按角色职责选择**：项目架构师需要项目管理、文档治理类技能；开发工程师需要代码、测试类技能
- **避免冗余**：相似功能的技能只保留一个
- **定期评估**：使用过程中发现不适用的技能及时移除

### 3.3 项目架构师技能清单（参考）

| 技能名称 | 用途 |
|---------|------|
| 150-pdf-reader | PDF内容提取、表格识别 |
| using-superpowers | 多任务执行规划 |
| knowledge-management | 知识管理、文档沉淀 |
| grill-me | 方案深度追问、压力测试 |
| to-issues | 开发任务拆分 |
| skill-scout | 技能搜索侦察 |
| skill-dev | 技能开发、全生命周期管理 |
| deep-research | 深度资料研究 |
| beautiful-feishu-whiteboard | 飞书画板生成 |
| task-management | 轻量化任务管理 |

## 四、AGENTS.md 最佳实践

### 4.1 结构规范

一个完整的AGENTS.md应包含以下部分：
1. **每次启动** - 启动时的读取顺序和前置检查
2. **Skill使用兼容规则** - 技能路径不可访问时的降级策略
3. **技能列表** - 技能文件、用户能力、适用条件与边界
4. **内置技能（无法移除）** - 系统内置技能说明
5. **最高优先级执行门禁** - 安全、权限、事实核查等硬约束
6. **核心场景路由** - 不同任务类型的处理流程
7. **核心工作流程** - 标准操作步骤
8. **交互规则** - 与用户沟通的规范
9. **异常处理** - 各种异常情况的处理方式
10. **运行底线** - 不可逾越的红线

### 4.2 编写原则

- **明确边界**：每个技能的适用条件和边界要写清楚，避免误用
- **降级策略**：技能路径不可访问时要有明确的降级方案
- **安全优先**：最高优先级执行门禁要放在显眼位置
- **可执行**：规则要具体、可执行，避免模糊表述

## 五、常见问题

### Q1: 为什么直接在主页面操作编辑器无效？
A: 编辑器在跨域iframe中（aily.doubao.com），主页面（www.doubao.com）无法直接访问iframe内的DOM。需要直接导航到iframe URL。

### Q2: 为什么粘贴内容被截断？
A: `document.execCommand('copy')`在复制大内容时有限制（约2300字符）。解决方案是使用`ClipboardEvent`直接在编辑器元素上触发paste事件。

### Q3: 为什么`navigator.clipboard.writeText()`不工作？
A: 剪贴板API需要用户交互权限（transient activation），且在自动化场景下不稳定。建议使用ClipboardEvent方法。

### Q4: 如何验证内容是否完整保存？
A: 保存后刷新页面，重新打开AGENTS.md，检查`.cm-content`的textContent长度和关键章节是否存在。

### Q5: 技能列表更新后AGENTS.md需要同步更新吗？
A: 是的。添加或移除技能后，需要同步更新AGENTS.md中的技能列表，保持配置一致性。

## 六、更新记录

| 日期 | 更新内容 |
|------|---------|
| 2026-08-30 | 初始版本，记录AGENTS.md编辑的ClipboardEvent解决方案和踩坑记录 |
