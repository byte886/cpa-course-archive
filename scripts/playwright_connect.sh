#!/bin/bash
# Playwright 连接脚本（优化版）
# 用途：附加到用户已登录的 Chrome 浏览器
# 注意：第一次连接时，Chrome 会弹出连接确认对话框，需要手动点击 "Allow & select" 按钮
#       之后连接会被记住，不需要再次确认

set -euo pipefail

# 动态获取项目目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"


SESSION_NAME="ga"

echo "========================================="
echo "  Playwright 连接脚本"
echo "========================================="

# 检查 Chrome 是否在运行
if ! pgrep -x "Google Chrome" > /dev/null; then
    echo "❌ Chrome 未运行，请先打开 Chrome 并登录高顿网站"
    exit 1
fi

echo "✅ Chrome 正在运行"

# 检测是否可以用AppleScript执行JavaScript（用于自动点击Allow & select）
APPLESCRIPT_JS_ENABLED=true
osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "1"' 2>/dev/null
if [ $? -ne 0 ]; then
    APPLESCRIPT_JS_ENABLED=false
    echo ""
    echo "========================================="
    echo "  ⚠️  建议开启 '允许 Apple 事件中的 JavaScript'"
    echo "========================================="
    echo "开启后，脚本可以自动点击 'Allow & select' 按钮，无需人工干预"
    echo ""
    echo "开启方法（只需一次）："
    echo "1. 切换到 Chrome 窗口"
    echo "2. 菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript"
    echo "   （点击后菜单项前会出现 ✓ 标记）"
    echo ""
    echo "如果不开启，第一次连接时需要手动点击 'Allow & select' 按钮"
    echo "========================================="
    echo ""
    read -p "是否已经开启？(y/n，选n将继续手动模式): " -t 10 ENABLED
    if [ "$ENABLED" = "y" ] || [ "$ENABLED" = "Y" ]; then
        APPLESCRIPT_JS_ENABLED=true
    fi
fi

# 检查是否已有连接确认页面
CONNECT_TAB_COUNT=$(osascript -e 'tell application "Google Chrome" to count of (tabs of every window whose URL contains "connect.html")' 2>/dev/null | tr -d ' ')

if [ "$CONNECT_TAB_COUNT" -gt 0 ]; then
    echo "⚠️  发现 $CONNECT_TAB_COUNT 个连接确认页面，正在切换..."
    # 切换到第一个连接确认页面
    osascript << 'EOF'
tell application "Google Chrome"
    repeat with w in windows
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if URL of t contains "connect.html" then
                set active tab index of w to tabIndex
                set index of w to 1
                activate
                exit repeat
            end if
        end repeat
    end repeat
end tell
EOF
    echo "✅ 已切换到连接确认页面"
    echo ""
    echo "========================================="
    echo "  请手动点击 'Allow & select' 按钮"
    echo "========================================="
    echo "在连接确认页面中，找到高顿网站的标签页（URL包含 glivepro.gaodun.com）"
    echo "点击该标签页右侧的 'Allow & select' 按钮"
    echo ""
    echo "（第一次连接需要手动确认，之后会自动记住，不需要再次确认）"
    echo "========================================="
    echo ""
    echo "等待您点击 'Allow & select'..."
else
    # 没有连接确认页面，直接尝试附加
    echo "正在附加到 Chrome 浏览器（Extension 模式）..."
    npx playwright cli -s=$SESSION_NAME attach --extension=chrome 2>&1 | head -5 &
    sleep 3

    # 检查是否出现了连接确认页面
    CONNECT_TAB_COUNT=$(osascript -e 'tell application "Google Chrome" to count of (tabs of every window whose URL contains "connect.html")' 2>/dev/null | tr -d ' ')

    if [ "$CONNECT_TAB_COUNT" -gt 0 ]; then
        echo "⚠️  Chrome 弹出了连接确认对话框"
        # 切换到连接确认页面
        osascript << 'EOF'
tell application "Google Chrome"
    repeat with w in windows
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if URL of t contains "connect.html" then
                set active tab index of w to tabIndex
                set index of w to 1
                activate
                exit repeat
            end if
        end repeat
    end repeat
end tell
EOF
        echo ""
        echo "========================================="
        echo "  请手动点击 'Allow & select' 按钮"
        echo "========================================="
        echo "在连接确认页面中，找到高顿网站的标签页（URL包含 glivepro.gaodun.com）"
        echo "点击该标签页右侧的 'Allow & select' 按钮"
        echo ""
        echo "（第一次连接需要手动确认，之后会自动记住，不需要再次确认）"
        echo "========================================="
        echo ""
        echo "等待您点击 'Allow & select'..."
    fi
fi

# 等待连接建立，最多等待120秒
for i in $(seq 1 120); do
    sleep 1
    CURRENT_URL=$(npx playwright cli -s=$SESSION_NAME eval "window.location.href" 2>&1 | grep -A1 "Result" | tail -1 | tr -d '"')
    if [ -n "$CURRENT_URL" ] && [ "$CURRENT_URL" != "undefined" ] && [[ "$CURRENT_URL" != *"connect.html"* ]] && [[ "$CURRENT_URL" != *"The browser"* ]]; then
        echo ""
        echo "✅ 连接成功！"
        echo "   当前页面: $CURRENT_URL"
        echo ""
        echo "后续操作可以直接使用: npx playwright cli -s=$SESSION_NAME <command>"
        exit 0
    fi
    # 每15秒提示一次
    if [ $((i % 15)) -eq 0 ]; then
        echo "等待中... ($i秒)"
    fi
done

echo ""
echo "❌ 等待超时（120秒）"
echo "请确认是否点击了 'Allow & select' 按钮"
echo "如果连接确认页面没有出现，请检查 Chrome 是否安装了 Playwright Extension"
exit 1
