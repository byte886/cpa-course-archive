# GitHub 工作流

本文档记录项目的 GitHub 访问配置、SSH 配置、代理设置和常见问题处理。

## 1. 访问方式对比

经测试（2026-08-27，国内网络环境）：

| 方式 | 结果 | 耗时 | 说明 |
|------|------|------|------|
| HTTPS 直连 | ❌ 失败 | 10秒超时 | github.com 被墙 |
| HTTPS + ClashX 代理 | ✅ 成功 | 3.0秒 | 需开代理，94KB/s |
| SSH (github.com:22) | ✅ 成功 | 5.2秒 | 走 SSH config 配置 |
| **SSH 直连 (ssh.github.com:443)** | ✅ **成功** | **3.3秒** | **不需要代理！** |

**推荐方式：SSH 直连 ssh.github.com:443**
- 不需要开 ClashX 代理
- 密钥认证，不需要每次输入 token
- 443 端口走 HTTPS 通道，国内通常不被墙

## 2. SSH 配置

`~/.ssh/config` 中 github.com 的配置：

```ssh-config
Host github.com
  HostName ssh.github.com
  Port 443
  User git
  IdentityFile ~/.ssh/id_rsa_softwawrecheng
  StrictHostKeyChecking accept-new
  # 注：ssh.github.com:443 国内可直连，无需代理
  # 如需代理可取消下一行注释：
  # ProxyCommand nc -X connect -x 127.0.0.1:7890 %h %p
```

### 密钥文件

- 路径：`~/.ssh/id_rsa_softwawrecheng`
- 关联 GitHub 账号：byte886（曾用名 Web3Stack404、softwarecheng）
- 公钥已添加到 GitHub 账号

### 测试连接

```bash
ssh -T git@github.com
# 预期输出：Hi byte886! You've successfully authenticated...
```

## 3. Git Remote 配置

项目使用 SSH 方式：

```bash
# 查看当前 remote
git remote -v

# 切换到 SSH（如当前是 HTTPS）
git remote set-url origin git@github.com:byte886/cpa-course-archive.git

# 切换到 HTTPS（如需）
git remote set-url origin https://github.com/byte886/cpa-course-archive.git
```

## 4. 代理配置

### 4.1 ClashX 代理

- 代理地址：`http://127.0.0.1:7890`
- 用于：GitHub HTTPS 访问、Google 搜索、Homebrew、npm 等
- 不用于：高顿课程页、百度 API、百度网盘（直连更快）

### 4.2 Git 临时使用代理（HTTPS 方式时）

```bash
# 单次 push 使用代理
git -c http.proxy=http://127.0.0.1:7890 -c https.proxy=http://127.0.0.1:7890 push origin master

# 永久配置（不推荐，SSH 方式更好）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

### 4.3 SSH 使用代理（如需）

在 `~/.ssh/config` 的 github.com 配置中添加：
```ssh-config
ProxyCommand nc -X connect -x 127.0.0.1:7890 %h %p
```

## 5. 常见问题处理

### 5.1 SSH 连接失败

**症状**：`ssh: connect to host ssh.github.com port 443: Connection refused`

**排查步骤**：
1. 测试网络：`ping ssh.github.com`
2. 测试 443 端口：`nc -zv ssh.github.com 443`
3. 如果直连失败，启用 SSH config 中的 ProxyCommand
4. 确认 ClashX 代理已开启（127.0.0.1:7890）

### 5.2 HTTPS push 失败

**症状**：`fatal: unable to access 'https://github.com/...': Failed to connect`

**解决方案**：
1. 切换到 SSH 方式（推荐）
2. 或使用代理：`git -c http.proxy=http://127.0.0.1:7890 push`

### 5.3 Permission denied (publickey)

**症状**：`git@github.com: Permission denied (publickey).`

**排查步骤**：
1. 确认密钥文件存在：`ls -la ~/.ssh/id_rsa_softwawrecheng`
2. 确认 SSH config 中 IdentityFile 路径正确
3. 测试连接：`ssh -vT git@github.com`（查看详细日志）
4. 确认公钥已添加到 GitHub 账号

### 5.4 Push 速度慢

**可能原因**：
1. 走了代理但代理速度慢 → 尝试 SSH 直连 443
2. 提交包含大文件 → 检查 `.gitignore` 是否排除了生成结果
3. 网络波动 → 重试

## 6. 提交规范

### 6.1 Commit Message 格式

```
<type>: <简短描述>

<详细描述（可选）>
```

**Type 类型**：
- `feat`：新功能
- `fix`：修复 bug
- `docs`：文档更新
- `refactor`：重构（不影响功能）
- `chore`：构建/工具/依赖调整
- `test`：测试相关

### 6.2 示例

```
docs: 添加项目维护规则，更新GitHub目录结构

- 添加项目维护规则（结构维护原则、检查触发时机、存储分工）
- 更新GitHub仓库目录结构（脚本统一放scripts/、文档按领域分类）
```

## 7. 参考资料

- [GitHub SSH 官方文档](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub 通过 HTTPS 端口使用 SSH](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)
