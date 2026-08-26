# 百度网盘 API 集成

## 应用信息

- 应用名称：CPA课程归档
- AppID：124199604
- 凭证加密存储：`.secrets/baidu_credentials.enc`（AES-256-CBC, 密码 lover123）
- 沙箱目录：`/apps/CPA课程归档/`（网盘客户端中显示为"我的应用数据/CPA课程归档/"）

## 关键限制

- **沙箱模式**：个人应用只能在 `/apps/CPA课程归档/` 下操作，沙箱外返回 31064 错误
- **个人开发者**：最多创建 1 个应用
- **代理要求**：API 调用需走 ClashX 代理 `127.0.0.1:7890`（直连超时）
- access_token 有效期 30 天，refresh_token 约 10 年

## OAuth 授权流程（authorization code）

1. 启动临时 HTTP 服务监听 localhost:8080
2. 浏览器打开：`https://openapi.baidu.com/oauth/2.0/authorize?response_type=code&client_id=<AppKey>&redirect_uri=http://localhost:8080&scope=basic,netdisk&display=page`
3. 用户授权后跳转 `localhost:8080/?code=<CODE>`
4. POST `https://openapi.baidu.com/oauth/2.0/token` 换 access_token：
   - grant_type=authorization_code, code, client_id, client_secret, redirect_uri
5. 刷新：grant_type=refresh_token, refresh_token, client_id, client_secret

## API 端点

基础 URL：`https://pan.baidu.com/rest/2.0/xpan/`

| 操作 | method | 关键参数 |
|------|--------|---------|
| 用户信息 | GET /nas?method=uinfo | access_token |
| 新建文件夹 | POST /file?method=mkdir | path（URL编码） |
| 列目录 | GET /file?method=list | dir, order, desc |
| 删除 | POST /file?method=filemanager&opera=delete | filelist（JSON数组） |
| 移动 | POST /file?method=filemanager&opera=move | filelist（JSON数组） |
| 上传预创建 | POST /file?method=precreate | path, size, block_list(MD5数组), autoinit=1 |
| 上传分片 | POST https://d.pcs.baidu.com/rest/2.0/pcs/superfile2?method=upload | access_token, type=tmpfile, path, uploadid, partseq=N |
| 合并分片 | POST /file?method=create | path, size, block_list, uploadid |

所有路径必须以 `/apps/CPA课程归档/` 开头。

## 目录结构

```
/apps/CPA课程归档/
├── 税法-蔡俊峻/
│   ├── 01_税法全面精讲01-税法总论/
│   │   ├── video.mp4
│   │   └── docs/
│   └── ...
└── 会计-罗翔/
    └── ...
```

## 错误码

| 码 | 含义 | 处理 |
|----|------|------|
| 0 | 成功 | — |
| 111 | token 过期 | refresh_token 刷新 |
| 31061 | 已存在 | mkdir 可忽略 |
| 31064 | 未授权 | 路径超出沙箱 |

## 管理入口

- 应用详情：https://pan.baidu.com/union/console/app/124199604
- 授权管理：https://passport.baidu.com/accountbind
- 完整创建过程文档：`docs/BAIDU_NETDISK_SETUP.md`
