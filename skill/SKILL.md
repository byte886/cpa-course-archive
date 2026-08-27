---
name: gaodun-course-downloader
description: "高顿 Glive 课程回放视频下载、解密、压缩与归档。支持 HLS AES-128 加密视频的密钥提取（通过 Playwright 注入 Worker hook）、1080P FHD 分片下载解密合并、H.265 压缩、讲义文档下载、百度网盘上传。当用户提到高顿、gaodun、glivepro、课程回放下载、CPA 课程视频、蔡俊峻、罗翔等关键词时使用。"
---

# 高顿 Glive 课程下载器

从 glivepro.gaodun.com 下载课程回放视频（HLS AES-128 加密），解密合并后压缩为 H.265 MP4，并归档讲义文档。

## 前置条件

1. **Playwright Extension 模式**：用户 Chrome 已安装 Playwright Extension 并提供 token（见 playwright skill）
2. **Node.js**：用于下载解密脚本
3. **ffmpeg**：`/usr/local/bin/ffmpeg`，需支持 libx265
4. **iTerm2**：压缩命令在 iTerm 窗口中运行，用户可直接看进度

## 加密方案（核心知识）

- 视频为标准 HLS，m3u8 含 `#EXT-X-KEY:METHOD=AES-128,URI=".../replay/authorize?...",IV=0x...`
- .ts 分片可公开下载，但内容是 AES-128-CBC 加密
- 密钥获取链路：authorize 接口返回 92 字节密文 → hls.js Worker 发 `postMessage({type:"decrypt",...})` 给主线程 → 主线程 WASM 解密 → 返回 32 字节响应
- **实际 AES key = 响应前 16 字节的原始 ASCII 字符串**（不是 hex 解码）
- IV 直接取自 m3u8 的 `IV=0x...`
- 每个分片用相同 IV 独立解密（标准 HLS 行为），`setAutoPadding(false)`

详细逆向分析见 [references/encryption.md](references/encryption.md)。

## 完整工作流

### 1. 连接浏览器

```bash
PLAYWRIGHT_MCP_EXTENSION_TOKEN=<token> npx playwright cli -s=ga attach --extension=chrome
```

### 2. 打开课程表并遍历回放

课程表 URL 格式：`https://glivepro.gaodun.com/course/<course_id>/class-schedule`

- 用 `snapshot`/`find` 找到"看回放"按钮
- **跳过"开班典礼"**（标题含"开班典礼"的场次）
- 点击"看回放"会在新标签页打开播放器（`v-glive.gaodun.com/player?token=...`）
- 切换到新标签页：`npx playwright cli -s=ga tab-select 1`

### 3. 捕获 FHD 密钥

在播放器标签页运行 capture_key.js（注入 Worker hook → reload → 播放 → 切换 1080P → 提取密钥）：

```bash
npx playwright cli -s=ga run-code scripts/capture_key.js
```

返回 JSON 包含 `streams` 数组，每项有 `quality`、`m3u8`、`keyAscii`。取 `FHD-1080P` 项。

**注意**：
- 自定义元素标签名（如 `G-3F001E35`）每次加载会变，通过 `.gp-video-wrap` 子元素遍历找 `.video` 属性
- 清晰度按钮 class：`.gp-setting-quality-item`，FHD 选项文本含"1080"
- 如果 FHD 切换后没有新密钥，检查视频是否已在播放（需 seek 到 0 并 play）

### 4. 下载 m3u8 和分片

```bash
# 下载 FHD m3u8
curl -s -o playlist.m3u8 "<fhd_m3u8_url>" \
  -H "User-Agent: Mozilla/5.0 ..." -H "Referer: https://v-glive.gaodun.com/"

# 下载+解密+合并全部分片（20并发，支持断点续传）
node scripts/download_decrypt.js playlist.m3u8 merged.ts ./segments <keyAscii> <iv_hex> 20
```

IV 从 m3u8 的 `#EXT-X-KEY` 行提取，去掉 `0x` 前缀。

### 5. 压缩（在 iTerm 中运行，显示实时进度）

```bash
# 在 iTerm 新标签页中运行（用户可见 ffmpeg 实时进度）
osascript -e "tell application \"iTerm\"
  tell current window
    create tab with default profile
    tell current session
      write text \"cd '<output_dir>'; bash '<skill_dir>/scripts/compress.sh' merged.ts video.mp4 30\"
    end tell
  end tell
end tell"
```

压缩参数：H.265 CRF 30（课件文字清晰、头像略糊但不影响学习）、AAC 96k、hvc1 标签、faststart。
压缩完成后 compress.sh 自动验证时长和可播放性。

### 6. 下载讲义文档

在课程表页，每个直播场次下有"讲义|"/"课件|"前缀的条目，带"下载"链接。

```bash
# 在浏览器中提取下载链接
npx playwright cli -s=ga eval "
(() => {
  const items = document.querySelectorAll('.gp-classmate-item, [class*=material]');
  // 遍历找到含'下载'的元素，提取 href 或 onclick 中的 URL
  ...
})()
"
```

下载 PDF 到对应场次的 `docs/` 子目录。

### 7. 目录结构

```
<download_root>/
├── 税法-蔡俊峻/
│   ├── 01_税法全面精讲01-税法总论/
│   │   ├── video.mp4          # 压缩后视频
│   │   ├── playlist.m3u8      # m3u8 备份
│   │   ├── segments/          # 解密分片缓存（可删除）
│   │   ├── merged.ts          # 合并后原始TS（可删除）
│   │   └── docs/              # 讲义课件 PDF
│   ├── 02_.../
│   └── ...
├── 会计-罗翔/
│   └── ...
└── _reports/                  # 任务报告
```

### 8. 验证清单

每个视频压缩后必须确认：
- [ ] ffprobe 能正常读取（moov atom 存在）
- [ ] 输出时长与输入时长差 < 2 秒
- [ ] 视频编码为 hevc，分辨率 1920x1080
- [ ] 音频编码为 aac
- [ ] 文件可正常播放（首尾都有画面）

### 9. 百度网盘上传（可选）

百度网盘开放平台 REST API 支持文件上传、目录管理（mkdir/move/delete/rename）。
配置和使用见 [references/baidupan.md](references/baidupan.md)。

### 10. 知识库建设与维护（扩展）

视频和讲义下载完成后，可进一步建设飞书知识库，将视频内容和讲义整理成可搜索、可问答的知识体系。

#### 10.1 知识库结构

```
CPA备考知识库/
└── CPA/
    ├── 课程库/                          ← 走完整流程（有知识库）
    │   └── 【课程名称】/
    │       ├── 00_开班典礼&规划方法/
    │       │   ├── 知识拆解
    │       │   └── 考试指导
    │       ├── 01税法总论/
    │       │   ├── 知识拆解            ← 核心知识点（定义、分类、原则、表格）
    │       │   └── 考试指导            ← 考点分析、做题技巧、易错点、记忆口诀
    │       └── ...
    └── 待整理/                          ← 未走完整流程（暂无知识库）
```

#### 10.2 知识库同步流程（核心规范）

**原则：先本地，后飞书；先验证，后同步。**

```
更新本地文档 → 验证本地文档 → 同步到飞书知识库 → 验证飞书知识库 → 结构检查与清理
```

**步骤5：结构检查与清理（必须执行）**

同步完成后，必须执行结构检查，避免出现重复节点、空节点、错误位置等问题：

```bash
# 使用项目中的知识库结构检查脚本
./scripts/check-kb-structure.sh <parent_node_token> [space_id]

# 示例：检查01税法总论节点
./scripts/check-kb-structure.sh XTJFwu5zBiUNCDkXqEgcTI2fnPg 7678261729456852192
```

**检查项**：
- 子节点列表（确认数量正确）
- 重复节点（同一层级下不能有同名节点）
- 空节点（只有标题，没有内容）
- 父节点链接（必须使用完整URL，不使用相对路径）
- 子节点是否都在父节点链接中

**清理操作（必须使用API，不使用Playwright）**：
- 发现重复节点：删除重复的、内容为空的或位置错误的节点
- 发现空节点：同步内容或删除
- 发现错误位置的节点：移动到正确位置或删除后重新创建

```bash
# 删除节点（高风险操作，需--yes确认）
lark-cli wiki +node-delete --node-token "<URL>" --yes

# 列出子节点
lark-cli wiki +node-list --space-id <space_id> --parent-node-token <node_token>

# 获取节点详情
lark-cli wiki +node-get --node-token "<URL>"
```

#### 10.3 父节点目录清单规范

每个父节点（课程节点和章节节点）必须包含目录清单，方便用户分享和导航。

**必须包含**：
1. 基本信息块（课程/章节名称、主讲老师、整理来源、适用范围、更新时间）
2. 子节点目录清单（完整URL链接，每个链接附带简要说明）
3. 章节概述（简要介绍主要内容和学习目标）
4. 重点内容（3-7条核心知识点）
5. 学习建议（学习顺序和方法）

**不包含**：
- 正文知识点内容（父页面只是目录，不承载知识内容）
- 文档维护说明（流程相关文档记录，不放在知识库中）

**模板**：见项目中的 `docs/development/templates/PARENT_NODE_TEMPLATE.md`

**链接规范**：必须使用完整的飞书URL（`https://zcnjheoajxng.feishu.cn/wiki/[node_token]`），不使用相对路径（如`./知识拆解`）。

#### 10.4 知识库操作原则

1. **API优先**：所有知识库操作（创建、更新、删除、移动节点）必须使用飞书API（lark-cli），不使用Playwright手动操作
2. **本地优先**：所有内容变更先在本地文档中完成，验证通过后再同步到飞书知识库
3. **结构检查**：每次同步后必须执行结构检查，避免重复节点、空节点、错误位置
4. **完整URL**：父节点目录清单中的链接必须使用完整飞书URL，不使用相对路径
5. **文档归属**：具体产出物（验证报告、同步报告）放在对应课程目录下，不放在通用目录

#### 10.5 相关文档与脚本

| 文档/脚本 | 位置 | 说明 |
|-----------|------|------|
| 知识库组织规范 | `docs/development/knowledge-base-organization.md` | 知识库结构设计、节点命名规范、父页面规范 |
| 知识库来源清单 | `docs/development/knowledge-base-sources.md` | 视频转写、讲义文档、用户留言等来源的整理流程 |
| 父节点目录清单模板 | `docs/development/templates/PARENT_NODE_TEMPLATE.md` | 章节父节点和课程父节点模板 |
| 知识库结构检查脚本 | `scripts/check-kb-structure.sh` | 自动检测重复节点、空节点、链接问题 |
| 飞书API使用说明 | `docs/development/feishu-api.md` | wiki节点删除、文档更新、权限设置、常见问题 |
| 总体工作流 | `docs/WORKFLOW.md` | 完整工作流（下载→压缩→转写→知识库→做题验证） |

## 关键陷阱

1. **Extension 模式下 CDP 不可用**（"Not allowed"），只能用 Playwright CLI 命令
2. **Worker hook 必须在 reload 前注入**（addInitScript），否则 Worker 已创建无法拦截
3. **密钥不是 hex 解码**：Worker 返回 32 字节 ASCII hex 字符串，但 hls.js 只读前 16 字节原始字节作为 AES key
4. **m3u8 token 会过期**：批量下载时需定期重新打开播放器获取新 token
5. **每个视频密钥不同**：必须逐个捕获，不能复用
6. **ref 是动态的**：每次页面变化后重新 snapshot/find
7. **播放器自定义元素在 closed shadow DOM 内**：通过 `.gp-video-wrap` 子元素的 `.video` 属性访问
8. **知识库操作必须使用API**：所有知识库操作（创建、更新、删除、移动节点）必须使用lark-cli，不使用Playwright手动操作
9. **父节点链接必须使用完整URL**：不能使用相对路径（如`./知识拆解`），必须使用完整飞书URL（`https://zcnjheoajxng.feishu.cn/wiki/[node_token]`）
10. **同步后必须执行结构检查**：避免出现重复节点、空节点、错误位置等问题，使用`scripts/check-kb-structure.sh`
11. **具体产出物放对应课程目录**：验证报告、同步报告等放在对应课程目录下，不放在通用目录
12. **删除节点是异步操作**：`lark-cli wiki +node-delete`是异步的，需要轮询任务状态确认完成
