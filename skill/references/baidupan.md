# 百度网盘 API 集成

## 准备工作

1. 访问 https://pan.baidu.com/union/home 注册为开发者
2. 创建应用，获取 AppKey（client_id）和 SecretKey（client_secret）
3. 完成实名认证
4. OAuth2 授权获取 access_token：
   - 设备码流程：`POST https://openapi.baidu.com/oauth/2.0/device/code?client_id=<key>&response_type=device_code&scope=basic,netdisk`
   - 用户在浏览器打开 https://openapi.baidu.com/device 输入 user_code 授权
   - 轮询 `https://openapi.baidu.com/oauth/2.0/token` 获取 access_token
5. access_token 有效期 30 天，需定期刷新

## API 端点

基础 URL：`https://pan.baidu.com/rest/2.0/xpan/`

### 文件管理

| 操作 | method | 路径 | 关键参数 |
|------|--------|------|---------|
| 上传（预创建） | precreate | /file | path, size, isdir=0, autoinit=1, block_list (MD5数组) |
| 上传分片 | upload | /file?method=upload | 分片二进制数据 |
| 创建文件 | create | /file | path, size, isdir=0, block_list |
| 新建文件夹 | mkdir | /file | path |
| 删除 | delete | /file?method=delete | filelist (JSON数组) |
| 移动 | move | /file?method=move | async, filelist |
| 重命名 | rename | /file?method=rename | filelist |
| 复制 | copy | /file?method=copy | filelist |
| 列目录 | list | /file?method=list | dir, order, desc, start, limit |
| 获取文件信息 | filemanager | /file?method=filemanager | filelist |

### 上传流程（分片）

1. **precreate**：检查文件是否已存在（MD5 秒传），返回 uploadid
2. **分片上传**：每片 4MB（建议），POST 到 `https://d.pcs.baidu.com/rest/2.0/pcs/superfile2?method=upload&access_token=...&type=tmpfile&path=...&uploadid=...&partseq=N`
3. **create**：所有分片上传完成后调用，服务端合并文件

## 建议目录结构

```
/CPA课程/
├── 税法-蔡俊峻/
│   ├── 01_税法全面精讲01-税法总论/
│   │   ├── video.mp4
│   │   └── docs/
│   ├── 02_.../
│   └── ...
├── 会计-罗翔/
│   └── ...
└── _reports/
```

## 注意事项

- 上传需要 access_token 作为 query 参数
- 单文件大小限制：普通开发者单个文件最大 2GB（分片上传可支持更大）
- API 有频率限制，批量操作间加延迟
- 上传大文件建议 4MB 分片，支持断点续传（记录已上传的 partseq）
- 百度网盘 AI 功能（简单听记、AI笔记）无开放 API，需在客户端手动操作
