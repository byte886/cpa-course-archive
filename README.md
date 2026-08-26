# 高顿 CPA 课程知识库项目

自动化下载高顿 Glive 平台 CPA 课程回放视频（HLS AES-128 加密），解密合并压缩后归档，并构建飞书知识库。

## 课程

- 【26考季】VIPCPA系列-税法（蔡俊峻老师）
- 【26考季】VIPCPA系列-会计（罗翔老师）

## 技术方案

- 浏览器自动化：Playwright Extension 模式附加 Chrome
- 密钥提取：Hook hls.js Worker 通信截获 AES-128 密钥
- 下载：Node.js 多线程下载 HLS 分片
- 解密：AES-128-CBC（密钥为 Worker 解密响应前16字节 ASCII）
- 压缩：ffmpeg H.265 CRF30 + AAC 96k
- 验证：ffprobe 自动校验时长和可播放性

## 目录结构

```
gaodun_downloads/
├── 税法-蔡俊峻/
│   ├── 01_税法全面精讲01-税法总论/
│   │   ├── video.mp4
│   │   └── docs/
│   └── ...
├── 会计-罗翔/
│   └── ...
├── _tools/           # 下载脚本
└── _reports/         # 任务报告
```

## 使用方法

使用 `gaodun-course-downloader` Skill 执行下载流程。

## 压缩参数

- 编码器：libx265 (H.265/HEVC)
- CRF：30（课件文字清晰，头像略糊但不影响学习）
- Preset：fast
- 音频：AAC 96kbps
- 全片约 246MB / 3小时15分
