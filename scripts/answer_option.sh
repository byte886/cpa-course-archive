#!/bin/bash
# 高顿教育做题脚本 - 点击指定选项（简化版，已验证可靠）
# 可靠性：通过文本内容匹配选项，不依赖ref
# 适用范围：选项标签为单个字母(A/B/C/D)的题目

set -euo pipefail

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"


SESSION="ga"
OPTION="$1"

if [ -z "$OPTION" ]; then
  echo "用法: $0 <选项(A/B/C/D)>"
  exit 1
fi

cd "$PROJECT_DIR"

# 使用JavaScript直接点击选项（简化版，已验证可靠）
# 匹配条件：文本精确匹配 + 元素可见 + 无子女元素
RESULT=$(npx playwright cli -s=$SESSION run-code "
async (page) => {
  return await page.evaluate((opt) => {
    const all = document.querySelectorAll('div, span, p, li');
    for (let el of all) {
      if (el.textContent.trim() === opt && 
          el.children.length === 0 &&
          el.offsetParent !== null) {
        el.click();
        return 'clicked ' + opt + ' (' + el.tagName + ', top=' + Math.round(el.getBoundingClientRect().top) + ')';
      }
    }
    return opt + ' not found';
  }, '$OPTION');
}" 2>&1 | grep -E "clicked|not found" | head -1)

echo "$RESULT"

# 验证：等待页面响应
sleep 2
