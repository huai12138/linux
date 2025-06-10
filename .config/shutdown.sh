#!/bin/bash

# 监测文件内容是否为1，是则关机，否则5分钟后再检测
SHUTDOWN_FILE="http://10.0.0.21/shutdown"

while true; do
    # 获取文件内容
    CONTENT=$(curl --output /dev/null --silent --write-out "%{stdout}" --connect-timeout 3 --max-time 5 --location --max-redirs 1 "$SHUTDOWN_FILE" 2>/dev/null | tr -d '[:space:]')
    
    echo "文件内容: '$CONTENT'"
    
    # 检查内容是否为1
    if [ "$CONTENT" = "1" ]; then
        echo "检测到关机信号 (内容为1)，准备关机..."
        sudo shutdown now
        exit 0
    else
        echo "未检测到关机信号 (内容: '$CONTENT')，5分钟后重试..."
        sleep 300  # 等待300秒（5分钟）
    fi
done
