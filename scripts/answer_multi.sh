#!/bin/bash
# 高顿教育做题脚本 - 多选题点击多个选项
# 可靠性：逐个调用answer_option.sh，每个选项独立验证
# 适用范围：选项标签为单个字母(A/B/C/D)的多选题
# 注意：多选题不会自动跳题，需要手动点击下一题

set -euo pipefail

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"


SESSION="ga"
OPTIONS="$@"

if [ -z "$OPTIONS" ]; then
  echo "用法: $0 <选项1> <选项2> [选项3] ..."
  echo "示例: $0 A B D"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 多选题：选择 $OPTIONS ==="

for opt in $OPTIONS; do
  echo "选择 $opt..."
  bash "$SCRIPT_DIR/answer_option.sh" "$opt"
  sleep 2
done

echo ""
echo "=== 所有选项已点击，请确认后点击下一题 ==="
