#!/bin/bash

# 监测URL是否存在，存在则关机，不存在则5分钟后再检测
URL="http://10.0.0.21:8080/shutdown"

while true; do
    # 方案2：使用 --max-redirects 0 禁止重定向
    if curl --output /dev/null --silent --head --fail --max-redirects 0 --connect-timeout 3 --max-time 6 "$URL"; then
        echo "检测到关机信号，准备关机..."
        sudo shutdown now
        exit 0
    else
        echo "未检测到关机信号，5分钟后重试..."
        sleep 300  # 等待300秒（5分钟）
    fi
done
