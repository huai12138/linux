#!/bin/zsh

# 目标IP和MAC地址
TARGET_IP="10.10.10.15"
MAC_ADDRESS="00:23:24:67:DF:14"
REMmina_CONFIG="$HOME/.config/10_10_10_15.remmina"

# 使用 ping 命令检查目标主机是否可达
ping -c 1 "$TARGET_IP" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    # 如果目标主机可达，则直接连接 Remmina
    echo "Windows系统已启动，连接中..."
    remmina -c "$REMmina_CONFIG" &
else
    # 如果目标主机不可达，则发送 Wake-On-LAN 信号
    echo "Windows系统未启动，正在唤醒..."
    wakeonlan "$MAC_ADDRESS" > /dev/null 2>&1
    
    # 正在等待机器启动
    echo "正在等待系统启动..."
    sleep 30
    
    # 唤醒后再连接 Remmina
    echo "重新连接 Remmina..."
    remmina -c "$REMmina_CONFIG" &
fi

