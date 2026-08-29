#!/bin/bash
# 高顿课程视频批量上传百度网盘脚本
# 在iTerm中运行，显示进度，支持断点续传
# 网盘路径必须以 /apps/CPA课程归档/ 开头

set -e

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 配置
UPLOAD_SCRIPT="$PROJECT_DIR/scripts/baidu_upload.py"
export BAIDU_ENC_PASS="lover123"

# 本地基础目录
LOCAL_BASE="$HOME/Desktop/高顿"
# 网盘基础目录（必须包含高顿层，与本地目录结构一致）
REMOTE_BASE="/apps/CPA课程归档/高顿"

# 要上传的视频列表（基础必修12个）
VIDEO_LIST=(
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/01_会计总论(一)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/02_会计总论(二)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/03_会计总论(三)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/04_会计总论(四)、资产(一)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/05_资产(二)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/06_资产(三)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/07_资产(四)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/08_资产(五)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/09_资产(六)、负债(一)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/10_负债(二)、所有者权益(一)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/11_所有者权益(二)、动态要素(一)/video.mp4"
  "CPA/待整理/【26考季】VIPCPA-基础必修-会计（罗翔老师）/12_动态要素(二)、财务报告/video.mp4"
)

TOTAL=${#VIDEO_LIST[@]}
SUCCESS=0
SKIPPED=0
FAILED=0
START_TIME=$(date +%s)

echo "============================================"
echo "  高顿课程视频批量上传百度网盘"
echo "  共 $TOTAL 个视频"
echo "  本地: $LOCAL_BASE"
echo "  网盘: $REMOTE_BASE"
echo "  开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
echo ""

for i in "${!VIDEO_LIST[@]}"; do
  REL_PATH="${VIDEO_LIST[$i]}"
  NUM=$((i + 1))
  LOCAL_FILE="$LOCAL_BASE/$REL_PATH"
  REMOTE_FILE="$REMOTE_BASE/$REL_PATH"
  
  # 获取课次名称
  LESSON_NAME=$(basename "$(dirname "$REL_PATH")")
  
  echo "[$NUM/$TOTAL] $LESSON_NAME"
  
  # 检查本地文件是否存在
  if [ ! -f "$LOCAL_FILE" ]; then
    echo "  [失败] 本地文件不存在: $LOCAL_FILE"
    FAILED=$((FAILED + 1))
    continue
  fi
  
  FILE_SIZE=$(du -m "$LOCAL_FILE" | cut -f1)
  echo "  本地: ${FILE_SIZE}MB"
  
  # 断点续传：检查网盘是否已有该文件（通过预创建API检查）
  # 简化处理：如果上传日志中记录成功则跳过
  LOG_FILE="$PROJECT_DIR/reports/upload_log_$(date +%Y%m%d).txt"
  if grep -q "$REL_PATH" "$LOG_FILE" 2>/dev/null; then
    echo "  [跳过] 已在上传日志中记录"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  
  # 执行上传
  echo "  [上传中] ..."
  UPLOAD_START=$(date +%s)
  
  if python3 "$UPLOAD_SCRIPT" "$LOCAL_FILE" "$REMOTE_FILE" 2>&1; then
    UPLOAD_END=$(date +%s)
    DURATION=$((UPLOAD_END - UPLOAD_START))
    echo "  [完成] 耗时 $((DURATION / 60))分$((DURATION % 60))秒"
    SUCCESS=$((SUCCESS + 1))
    # 记录上传日志
    echo "$(date '+%Y-%m-%d %H:%M:%S') 成功  $REL_PATH  ${FILE_SIZE}MB" >> "$LOG_FILE"
  else
    echo "  [失败] 上传出错"
    FAILED=$((FAILED + 1))
    echo "$(date '+%Y-%m-%d %H:%M:%S') 失败  $REL_PATH" >> "$LOG_FILE"
  fi
  
  # 显示总体进度
  ELAPSED=$(( $(date +%s) - START_TIME ))
  PROCESSED=$((SUCCESS + SKIPPED + FAILED))
  if [ $PROCESSED -gt 0 ]; then
    AVG_TIME=$((ELAPSED / PROCESSED))
    REMAINING=$(( (TOTAL - PROCESSED) * AVG_TIME ))
    echo "  [进度] 已处理 $PROCESSED/$TOTAL，已用 $((ELAPSED / 60))分$((ELAPSED % 60))秒，预计剩余 $((REMAINING / 60))分$((REMAINING % 60))秒"
  fi
  echo ""
done

# 汇总报告
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

echo "============================================"
echo "  批量上传完成"
echo "  完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "  总耗时: $((TOTAL_DURATION / 60))分$((TOTAL_DURATION % 60))秒"
echo "  ----------------------------------------"
echo "  成功: $SUCCESS"
echo "  跳过: $SKIPPED"
echo "  失败: $FAILED"
echo "  总计: $TOTAL"
echo "  日志: $LOG_FILE"
echo "============================================"

if [ $FAILED -gt 0 ]; then
  exit 1
fi
