#!/bin/bash
# 高顿教育做题脚本 - 交卷
# 可靠性：通过文本内容匹配交卷按钮，不依赖ref
# 适用范围：高顿教育考试页面

SESSION="ga"

cd /Users/wenjiechen/Doubao/chats/2026-08-26/new-chat/gaodun_downloads

echo "=== 点击交卷 ==="
npx playwright cli -s=$SESSION run-code "
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
}" 2>&1 | tail -3

sleep 5

echo ""
echo "=== 确认交卷 ==="
npx playwright cli -s=$SESSION run-code "
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
}" 2>&1 | tail -3

sleep 15

echo ""
echo "=== 查看成绩 ==="
npx playwright cli -s=$SESSION eval "document.body.innerText.substring(0, 150)" 2>&1 | tail -8
