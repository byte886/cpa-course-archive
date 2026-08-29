# 质量保证规范（Quality Assurance）

> **文档类型**：Governance（治理规范）
> **更新频率**：规范变更时
> **维护者**：AI自动维护+用户审核
> **读者**：AI代理

> 本文档定义项目中各类产出物的验证标准和流程，确保交付质量。
> 适用范围：知识梳理文档、转写文本、视频压缩、文档上传等所有产出物。

---

## 一、知识梳理文档验证规范

### 1.1 验证时机

- 知识梳理文档（knowledge.md）生成后，**必须**执行验证
- 验证通过后才能同步到飞书知识库
- 验证报告随文档一起提交到项目仓库

### 1.2 验证清单

| 编号 | 验证项 | 验证方法 | 通过标准 |
|------|--------|----------|----------|
| V1 | 文件基本信息 | 统计文件大小、行数、字数 | 非空，内容充实（建议>3000中文字） |
| V2 | 内容完整性 | grep检查每节标题 | 所有章节全部存在，无遗漏 |
| V3 | 考点标注 | 统计考点提示/易错点/记忆口诀/真题/高频考点 | 每类至少1个，总计>5个 |
| V4 | 表格使用 | 统计Markdown表格 | 关键对比内容使用表格（>3个表格） |
| V5 | 关键知识点抽查 | grep检查核心关键词 | 抽查的关键词全部存在 |
| V6 | 来源标注 | 检查文档头部来源说明 | 明确标注转写和讲义来源，无编造 |
| V7 | 结构清晰度 | 人工检查目录层次 | 有框架图，层次分明，便于定位 |
| V8 | 内容准确性 | 人工抽查关键知识点 | 抽查无明显错误 |

### 1.3 验证执行方式

```bash
# 自动化检查（V1-V6）
KNOWLEDGE_FILE="path/to/knowledge.md"

# V1: 文件基本信息
echo "大小: $(wc -c < "$KNOWLEDGE_FILE") 字节"
echo "行数: $(wc -l < "$KNOWLEDGE_FILE") 行"
echo "中文字数: $(grep -o '[一-龥]' "$KNOWLEDGE_FILE" | wc -l) 字"

# V2: 章节完整性
for section in "第一节" "第二节" "第三节" ...; do
    grep -q "$section" "$KNOWLEDGE_FILE" && echo "✅ $section" || echo "❌ $section"
done

# V3: 考点标注
echo "考点提示: $(grep -c '考点提示' "$KNOWLEDGE_FILE")"
echo "易错点: $(grep -c '易错点' "$KNOWLEDGE_FILE")"
echo "记忆口诀: $(grep -c '记忆口诀' "$KNOWLEDGE_FILE")"
echo "真题回顾: $(grep -c '真题回顾' "$KNOWLEDGE_FILE")"
echo "高频考点: $(grep -c '高频考点' "$KNOWLEDGE_FILE")"

# V5: 关键词抽查
for keyword in "关键词1" "关键词2" ...; do
    grep -q "$keyword" "$KNOWLEDGE_FILE" && echo "✅ $keyword" || echo "❌ $keyword"
done
```

### 1.4 验证报告模板

验证报告命名格式：`VERIFICATION_{对象类型}.md`（如 `VERIFICATION_knowledge.md`）

**模板位置**：`docs/development/templates/VERIFICATION_TEMPLATE.md`

**具体报告位置**：放在**对应课程目录下**，和被验证的对象在一起（如 `01_税法全面精讲01-税法总论/VERIFICATION_knowledge.md`）

> **文件归属原则**：针对具体课程/讲座的产出物（验证报告、测试计划等），放在对应课程目录下；通用模板和规范放在 `docs/` 或 `reports/` 下。

报告内容：
1. 验证基本信息（时间、对象、验证方式）
2. 验证过程（验证清单）
3. 验证结果（各项检查结果）
4. 发现的问题（按严重程度分类）
5. 验证结论（通过/不通过）
6. 后续建议

参考实例：`data/高顿/CPA/课程库/.../01_税法全面精讲01-税法总论/VERIFICATION_knowledge.md`

### 1.5 问题处理

| 严重程度 | 处理方式 |
|----------|----------|
| 高（内容错误/遗漏重要章节） | 必须修复，重新验证 |
| 中（考点标注不足/结构不清晰） | 建议修复，可后续优化 |
| 低（格式问题/个别真题未标年份） | 记录问题，后续批量优化 |

---

## 二、视频压缩验证规范

### 2.1 验证清单

| 编号 | 验证项 | 验证方法 | 通过标准 |
|------|--------|----------|----------|
| V1 | 文件完整性 | ffprobe检查时长 | 压缩后时长与原片误差<2秒 |
| V2 | 可播放性 | ffprobe检查编码格式 | H.265/H.264 + AAC，无损坏 |
| V3 | 画质检查 | 人工抽查关键帧 | 文字清晰，头像可辨认 |
| V4 | 音质检查 | 人工试听 | 声音清晰，无杂音 |
| V5 | 体积检查 | 统计文件大小 | 3小时视频<300MB（可根据内容调整） |

### 2.2 验证命令

```bash
# V1+V2: ffprobe自动检查
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO_FILE"

# 编码格式检查
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1 "$VIDEO_FILE"
```

---

## 三、文档上传验证规范

### 3.1 验证清单

| 编号 | 验证项 | 验证方法 | 通过标准 |
|------|--------|----------|----------|
| V1 | 文件完整性 | 对比本地和网盘文件大小/MD5 | 完全一致 |
| V2 | 目录结构 | 对比本地和网盘目录树 | 结构一致 |
| V3 | 可访问性 | 网盘端打开文件检查 | 可正常打开 |

---

## 四、验证报告归档

- 验证报告模板：`docs/development/templates/VERIFICATION_TEMPLATE.md`
- 具体验证报告：放在**对应课程目录下**（和被验证对象在一起）
- 命名格式：`VERIFICATION_{对象类型}.md`（如 `VERIFICATION_knowledge.md`）
- 验证报告随课程产出物一起同步到百度网盘
- 验证通过后，在任务状态文档中标记"已验证"

---

## 五、持续改进

- 每次验证后，如发现验证清单有遗漏，及时补充到本文档
- 如验证流程需要自动化，可考虑沉淀为 Skill
- 定期回顾验证结果，统计常见问题，优化生成流程

---

> 本文档是项目质量保证的标准规范，所有产出物必须按此规范验证后才能交付。
