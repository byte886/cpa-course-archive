#!/bin/bash
# 高顿教育做题脚本 - 交卷
# 可靠性：通过文本内容匹配交卷按钮，不依赖ref
# 适用范围：高顿教育考试页面

set -euo pipefail

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SESSION="ga"

cd "$PROJECT_DIR"

echo "=== 点击交卷 ==="
result=$(npx playwright cli -s=$SESSION run-code "
async (page) => {
  return await page.evaluate(() => {
    const elements = document.querySelectorAll('*');
    for (let el of elements) {
      if (el.textContent.trim() === '交卷' && el.children.length === 0) {
        el.click();
        return 'clicked 交卷';
      }
    }
    return '交卷 button not found';
  });
}" 2>&1)
echo "$result" | tail -3

if echo "$result" | grep -q "not found"; then
  echo "ERROR: 未找到交卷按钮"
  exit 1
fi

sleep 5

echo ""
echo "=== 确认交卷 ==="
result=$(npx playwright cli -s=$SESSION run-code "
async (page) => {
  return await page.evaluate(() => {
    const elements = document.querySelectorAll('*');
    for (let el of elements) {
      if (el.textContent.trim() === '确认交卷' && el.children.length === 0) {
        el.click();
        return 'clicked 确认交卷';
      }
    }
    return '确认交卷 button not found';
  });
}" 2>&1)
echo "$result" | tail -3

if echo "$result" | grep -q "not found"; then
  echo "WARNING: 未找到确认交卷按钮（可能已自动交卷）"
fi

sleep 15

echo ""
echo "=== 查看成绩 ==="
npx playwright cli -s=$SESSION eval "document.body.innerText.substring(0, 150)" 2>&1 | tail -8
