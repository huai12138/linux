#!/bin/bash

# dwl status script - 适配 dwl bar 补丁
# 基于补丁: https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/bar/bar-0.7.patch
# 
# 使用方法:
# 1. 确保 dwl 已经应用了 bar 补丁并编译
# 2. 给脚本添加执行权限: chmod +x dwl_status.sh
# 3. 运行: ./dwl_status.sh | dwl
# 
# dwl bar 补丁通过 stdin 接收状态文本并显示在状态栏上

# 获取网络接口名称（在循环外执行一次）
INTERFACE=$(ip route | awk '/default/ {print $5; exit}')

# 自动单位转换函数（移到循环外）
get_speed() {
    local bytes=$1
    local mb=$(awk "BEGIN{printf \"%.2f\", $bytes/1048576}")
    echo "${mb}MB/s"
}

# 缓存系统架构信息（移到循环外）
ARCH=$(uname -r | cut -d'-' -f1)

# 缓存文件路径
NET_RX_FILE="/sys/class/net/$INTERFACE/statistics/rx_bytes"
NET_TX_FILE="/sys/class/net/$INTERFACE/statistics/tx_bytes"

# 初始化网速计算的变量
NETWORK_ENABLED=false
if [[ -n "$INTERFACE" && -r "$NET_RX_FILE" && -r "$NET_TX_FILE" ]]; then
    RX1=$(< "$NET_RX_FILE")
    TX1=$(< "$NET_TX_FILE")
    NETWORK_ENABLED=true
fi

# 初始化CPU计算
read cpu1 idle1 <<< $(awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5; exit}' /proc/stat)

# dwl 状态输出函数 - 直接输出到 stdout 供 dwl 读取
output_status() {
    local status="$1"
    # dwl bar 补丁会从 stdin 读取状态文本
    printf "%s\n" "$status"
}

# 确保立即输出，无缓冲
exec 1> >(stdbuf -oL cat)

while true; do
    # 实时CPU计算
    read cpu2 idle2 <<< $(awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5; exit}' /proc/stat)
    total=$((cpu2 - cpu1))
    idle=$((idle2 - idle1))
    if (( total > 0 )); then
        usage=$(( (100 * (total - idle)) / total ))
    else
        usage=0
    fi
    cpu=$(printf "%02d%%" "$usage")
    cpu1=$cpu2
    idle1=$idle2
    
    # 系统信息
    mem=$(awk '/^MemTotal:|^MemAvailable:/ {
        if ($1 == "MemTotal:") total = $2/1024
        if ($1 == "MemAvailable:") avail = $2/1024
    } END {printf "%d/%dMB", (total-avail), total}' /proc/meminfo)
    
    temp=$(sensors 2>/dev/null | awk '/Core 0|Package id 0|CPU/ {for(i=1;i<=NF;i++) if($i~/\+[0-9]+\.[0-9]+°C/) {gsub(/\+|°C/,"",$i); printf "%.0f°C",$i; exit}}' || echo "N/A")
    time=$(date "+%a %b %d %H:%M")
    
    # 音频信息 - Wayland 兼容
    # 使用 pactl 和 wpctl (pipewire) 的兼容方式
    if command -v wpctl >/dev/null 2>&1; then
        # PipeWire 方式
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | 
                 awk '{printf "%02d%%", $2*100}')
    else
        # PulseAudio 方式
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | 
                 awk '{gsub(/%/, "", $5); printf "%02d%%", $5; exit}')
    fi
    [[ -z "$volume" ]] && volume="N/A"
    
    # 音乐信息 - 支持多种播放器
    if command -v playerctl >/dev/null 2>&1; then
        # 使用 playerctl (更适合 Wayland)
        music=$(playerctl metadata --format "{{ title }}" 2>/dev/null)
        music="[${music:-N/A}]"
    elif command -v mpc >/dev/null 2>&1; then
        # 传统 MPD 方式
        music=$(mpc current 2>/dev/null | awk -F' - ' '{print $2}')
        music="[${music:-N/A}]"
    else
        music="[N/A]"
    fi
    
    # 输入法状态 - Wayland 兼容
    if command -v fcitx5-remote >/dev/null 2>&1; then
        fcitx5_status=$(fcitx5-remote 2>/dev/null)
        case $fcitx5_status in
            2) fcitx5_display="CN" ;;
            1) fcitx5_display="EN" ;;
            *) fcitx5_display="Er" ;;
        esac
    elif [[ -n "$XKB_DEFAULT_LAYOUT" ]]; then
        # 如果设置了键盘布局环境变量
        fcitx5_display="$XKB_DEFAULT_LAYOUT"
    else
        fcitx5_display="EN"
    fi

    # 计算网速
    if $NETWORK_ENABLED; then
        RX2=$(< "$NET_RX_FILE")
        TX2=$(< "$NET_TX_FILE")

        RX_DIFF=$((RX2 - RX1))
        TX_DIFF=$((TX2 - TX1))

        RX_SPEED=$(get_speed $RX_DIFF)
        TX_SPEED=$(get_speed $TX_DIFF)

        RX1=$RX2
        TX1=$TX2

        net_speed=" $RX_SPEED  $TX_SPEED"
    else
        net_speed=" N/A"
    fi

    # 设置 dwl 状态显示
    status_text="󰣇 $ARCH|♫ $music| $temp| $cpu| $mem| $volume|$net_speed|󰃰 $time|$fcitx5_display"
    output_status "$status_text"
    
    sleep 1
done
