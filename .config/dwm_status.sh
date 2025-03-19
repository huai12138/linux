#!/bin/bash

INTERFACE=$(ip route | awk '/default/ {print $5}')  # 你的网络接口名，可改成 `ip route | awk '/default/ {print $5}'` 自动获取

while true; do
    arch=$(uname -a | awk '{print $3}' | awk -F'-' '{print $1}')
    cpu=$(top -bn1 | awk '/%Cpu/{print 100 - $8"%"}')
    fcitx5_status=$(fcitx5-remote)

    # 判断输入法状态
    if [[ $fcitx5_status -eq 2 ]]; then
        fcitx5_display="中"
    elif [[ $fcitx5_status -eq 1 ]]; then
        fcitx5_display="EN"
    else
        fcitx5_display="Error"
    fi

    mem=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    music=$(mpc current)
    temp=$(awk '{print $1/1000"°C"}' /sys/class/thermal/thermal_zone0/temp)
    time=$(date | awk '{print $1,$2,$3,$4,$5}')
    # 计算网速（如果 INTERFACE 为空，则跳过）
    if [[ -n "$INTERFACE" && -d "/sys/class/net/$INTERFACE" ]]; then
        RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
        TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
        sleep 1
        RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
        TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

        RX_SPEED=$(( (RX2 - RX1) / 1024 ))  # 单位 KB/s
        TX_SPEED=$(( (TX2 - TX1) / 1024 ))  # 单位 KB/s

        net_speed=" ${RX_SPEED}KB/s  ${TX_SPEED}KB/s"
    else
        net_speed="Error"
    fi
    # 设置 xsetroot 显示
    xsetroot -name "󰣇 $arch | ♫ $music |  $temp | $cpu | $mem |  $volume | $net_speed | 󰃰 $time | $fcitx5_display"

done

