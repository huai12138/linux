#!/bin/bash

# 监测URL是否存在，存在则关机，不存在则5分钟后再检测
URL="http://10.0.0.21/shutdown"

while true; do
    # 减少超时参数：连接超时2秒，总操作时间不超过5秒
    if curl --output /dev/null --silent --head --fail --connect-timeout 3 --max-time 6 "$URL"; then
        sudo shutdown now
        exit 0
    else
        sleep 300  # 等待300秒（5分钟）
    fi
done