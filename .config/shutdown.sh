#!/bin/bash

# 监测URL是否存在，存在则关机，不存在则5分钟后再检测
URL="http://10.0.0.21:8080/shutdown"

while true; do
    # 获取HTTP状态码，只有200才认为是关机信号
    HTTP_STATUS=$(curl --output /dev/null --silent --write-out "%{http_code}" --connect-timeout 3 --max-time 6 --max-redirects 0 "$URL")
    
    echo "HTTP状态码: $HTTP_STATUS"
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "检测到关机信号 (HTTP 200)，准备关机..."
        sudo shutdown now
        exit 0
    else
        echo "未检测到关机信号，5分钟后重试..."
        sleep 300  # 等待300秒（5分钟）
    fi
done
