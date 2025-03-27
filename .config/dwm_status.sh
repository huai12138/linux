#!/bin/bash

# 获取网络接口名称（在循环外执行一次）
INTERFACE=$(ip route | awk '/default/ {print $5}')

# 初始化网速计算的变量
if [[ -n "$INTERFACE" && -d "/sys/class/net/$INTERFACE" ]]; then
    RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
fi

while true; do
    # 系统信息
    arch=$(uname -a | awk '{print $3}' | awk -F'-' '{print $1}')
    cpu=$(top -bn1 | awk '/%Cpu/{print 100 - $8"%"}')
    mem=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
    temp=$(awk '{print $1/1000"°C"}' /sys/class/thermal/thermal_zone0/temp)
    time=$(date | awk '{print $1,$2,$3,$4,$5}')
    
    # 音频信息
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    music=$(mpc current 2>/dev/null)
    music=${music:-"Stop"}
    
    # 输入法状态
    fcitx5_status=$(fcitx5-remote 2>/dev/null)
    if [[ $fcitx5_status -eq 2 ]]; then
        fcitx5_display="中"
    elif [[ $fcitx5_status -eq 1 ]]; then
        fcitx5_display="EN"
    else
        fcitx5_display="Error"
    fi

    # 计算网速
    if [[ -n "$INTERFACE" && -d "/sys/class/net/$INTERFACE" ]]; then
        RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
        TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

        RX_SPEED=$(( (RX2 - RX1) / 1024 ))  # 单位 KB/s
        TX_SPEED=$(( (TX2 - TX1) / 1024 ))  # 单位 KB/s

        # 更新基准值用于下次计算
        RX1=$RX2
        TX1=$TX2

        net_speed=" ${RX_SPEED}KB/s  ${TX_SPEED}KB/s"
    else
        net_speed="Error"
    fi

    # 设置 xsetroot 显示
    xsetroot -name "󰣇 $arch | ♫ $music |  $temp |  $cpu |   $mem |  $volume | $net_speed | 󰃰 $time | $fcitx5_display"

    # 固定更新间隔
    sleep 1
done
