#!/bin/bash

(
# 目标主机信息
TARGET_HOST="huai-PC"
TARGET_IP="192.168.8.15"  # 直接指定 IP 地址
MAC_ADDRESS="00:23:24:67:DF:14"
INTERFACE="enp0s31f6"
MAX_TRIES=30

# 检查必要命令是否安装
for cmd in arping wakeonlan xfreerdp3 notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send "错误" "$cmd 未安装，请先安装它。"
        exit 1
    fi
done

# 检查目标主机是否在线
if sudo arping -c 1 -w 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
    notify-send "远程连接" "Windows 系统已启动，正在连接..." && play ~/.config/dunst/system_online.mp3 > /dev/null 2>&1
    nohup xfreerdp3 /v:192.168.8.15 /u:huai /p:110 /sound /dynamic-resolution /cert:ignore > /dev/null 2>&1 &
    notify-send "连接中" "请稍候..." && play ~/.config/dunst/connecting.mp3 > /dev/null 2>&1
else
    notify-send "唤醒主机" "Windows 系统未启动，正在唤醒..." && play ~/.config/dunst/wol.mp3 > /dev/null 2>&1
    if wakeonlan "$MAC_ADDRESS" > /dev/null 2>&1; then
        notify-send "WOL 成功" "唤醒数据包已发送。"
    else
        notify-send "WOL 失败" "发送唤醒数据包失败，请检查网络。"
        exit 1
    fi

    notify-send "系统启动" "正在等待系统上线..." && play ~/.config/dunst/starting.mp3 > /dev/null 2>&1	
    for ((i=1; i<=MAX_TRIES; i++)); do
        if sudo arping -c 1 -w 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
            notify-send "系统已启动" "主机 $TARGET_HOST 已上线。" && play ~/.config/dunst/system_online.mp3 > /dev/null 2>&1
            break
        fi
        notify-send "等待中" "正在检测系统状态..."   
        sleep 1
    done

    if (( i > MAX_TRIES )); then
        notify-send "超时" "尝试 $MAX_TRIES 次后，未能连接到 $TARGET_HOST。"
        exit 1
    fi

    notify-send "开始连接" "FreeRDP 正在启动，请稍候..." && play ~/.config/dunst/connecting.mp3 > /dev/null 2>&1
    nohup xfreerdp3 /v:192.168.8.15 /u:huai /p:110 /sound /dynamic-resolution /cert:ignore > /dev/null 2>&1 &
    notify-send "连接中" "请稍候..." > /dev/null 2>&1
fi
sleep 3
rm -f windows.log
) > windows.log 2>&1 &

