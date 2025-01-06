#!/bin/bash

TARGET_HOST="huai-PC"
MAC_ADDRESS="00:23:24:67:DF:14"
REMmina_CONFIG="$HOME/.config/huai-PC.remmina"
INTERFACE="enp0s31f6"
MAX_TRIES=6

# 检查必要命令
for cmd in arping wakeonlan remmina; do
    command -v "$cmd" >/dev/null || { echo "$cmd 未安装，请先安装它。"; exit 1; }
done

# 解析主机名为 IP 地址
TARGET_IP=$(getent ahosts "$TARGET_HOST" | awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {print $1; exit}')
if [[ -z "$TARGET_IP" ]]; then
    echo "无法解析主机名 '$TARGET_HOST'，请检查 /etc/hosts 或 DNS 设置。"
    exit 1
fi

#echo "目标主机名：$TARGET_HOST"
#echo "目标 IP 地址：$TARGET_IP"
#echo "使用接口：$INTERFACE"

# 检查配置文件是否存在
if [[ ! -f "$REMmina_CONFIG" ]]; then
    echo "Remmina 配置文件不存在，请检查路径：$REMmina_CONFIG"
    exit 1
fi

# 使用 arping 检查目标主机是否可达
if sudo arping -c 1 -w 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
    echo "Windows 系统已启动，连接中..."
    nohup remmina -c "$REMmina_CONFIG" > /dev/null 2>&1 &
    sleep 5
    echo "连接成功，祝您愉快"
else
    echo "Windows 系统未启动，正在唤醒..."
    if wakeonlan "$MAC_ADDRESS" > /dev/null 2>&1; then
        echo "唤醒数据包已发送。"
    else
        echo "发送唤醒数据包失败！"
        exit 1
    fi

    echo "正在等待系统启动..."
    for ((i=1; i<=MAX_TRIES; i++)); do
        if sudo arping -c 1 -w 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
            echo "系统已上线"
            break
        fi
        echo "检测系统状态 ($i/$MAX_TRIES)..."
        sleep 5
    done

    if (( i > MAX_TRIES )); then
        echo "等待 $MAX_TRIES 次尝试后，连接超时，请检查网络或目标主机。"
        exit 1
    fi

    echo "开始连接..."
    sleep 5
    echo "正在连接中..."
    nohup remmina -c "$REMmina_CONFIG" > /dev/null 2>&1 &
    sleep 5
    echo "连接成功，祝您愉快"
fi
