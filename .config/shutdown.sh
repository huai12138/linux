#!/bin/bash

# 监测URL是否存在，存在则关机，不存在则5分钟后再检测
URL="http://10.0.0.21:8080/shutdown"

while true; do
    # 跟随重定向，但限制最大重定向次数，获取最终状态码
    HTTP_STATUS=$(curl --output /dev/null --silent --write-out "%{http_code}" --connect-timeout 3 --max-time 5 --location --max-redirs 3 "$URL")
    
    echo "HTTP状态码: $HTTP_STATUS"
    
    # 只有最终返回200才关机
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "检测到关机信号 (HTTP 200)，准备关机..."
        sudo shutdown now
        exit 0
    elif [[ "$HTTP_STATUS" =~ ^3[0-9][0-9]$ ]]; then
        echo "检测到重定向 ($HTTP_STATUS)，但未到达最终目标，非关机信号"
    else
        echo "未检测到关机信号 (状态码: $HTTP_STATUS)，5分钟后重试..."
        sleep 300  # 等待300秒（5分钟）
    fi
done
