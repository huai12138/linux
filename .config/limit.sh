#!/bin/zsh

GAME_PROCESS="Stardew Valley"
MAX_PLAY_TIME=$((120 * 60))  # 120 分钟（以秒为单位）
WARNING_TIME=$((60 * 60))    # 60 分钟（以秒为单位）

while true; do
    # 检查游戏是否在运行
    if ps aux | grep -i "[S]tardew Valley" > /dev/null; then
        notify-send -u normal "星露谷物语" "检测到游戏启动，计时开始！"
        sleep $WARNING_TIME
        notify-send -u critical "星露谷物语" "瑶老登已经玩了 一小时，请注意！"
        sleep $((MAX_PLAY_TIME - WARNING_TIME))
        notify-send -u critical "星露谷物语" "时间到了,瑶老登还有 1 分钟来保存，游戏将强制退出！"
        sleep 60  # 等待 1 分钟以便用户保存
        pkill -f "[S]tardew Valley"  # 强制结束游戏进程
        notify-send  "星露谷物语" "游戏已强制退出！"
    else
    fi
    sleep 60  # 每 60 秒检查一次游戏状态
done

