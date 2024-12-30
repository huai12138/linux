#!/bin/zsh

TARGET_HOST="huai-PC"
MAC_ADDRESS="00:23:24:67:DF:14"
REMmina_CONFIG="$HOME/.config/huai-PC.remmina"
INTERFACE="enp0s31f6"
MAX_TRIES=30

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

# 检查必要命令
for cmd in arping wakeonlan remmina; do
    command -v "$cmd" >/dev/null || { log "$cmd 未安装，请先安装它。"; exit 1; }
done

# 解析主机名为 IP 地址
TARGET_IP=$(getent ahosts "$TARGET_HOST" | awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {print $1; exit}')
if [[ -z "$TARGET_IP" ]]; then
    log "无法解析主机名 '$TARGET_HOST'，请检查 /etc/hosts 或 DNS 设置。"
    exit 1
fi

log "目标主机名：$TARGET_HOST"
log "目标 IP 地址：$TARGET_IP"
log "使用接口：$INTERFACE"

# 检查配置文件是否存在
if [[ ! -f "$REMmina_CONFIG" ]]; then
    log "Remmina 配置文件不存在，请检查路径：$REMmina_CONFIG"
    exit 1
fi

# 使用 arping 检查目标主机是否可达
if sudo arping -c 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
    log "Windows 系统已启动，连接中..."
    remmina -c "$REMmina_CONFIG" > /dev/null 2>&1 &
    sleep 5
    log "连接成功，祝您愉快"
else
    log "Windows 系统未启动，正在唤醒..."
    wakeonlan "$MAC_ADDRESS" > /dev/null 2>&1

    log "正在等待系统启动..."
    for ((i=1; i<=MAX_TRIES; i++)); do
        if sudo arping -c 1 -q -I "$INTERFACE" "$TARGET_IP" > /dev/null 2>&1; then
            log "系统已上线"
            break
        fi
        log "尝试连接 ($i/$MAX_TRIES)..."
        sleep 0.5
    done

    if (( i > MAX_TRIES )); then
        log "等待 $MAX_TRIES 次尝试后，连接超时，请检查网络或目标主机。"
        exit 1
    fi

    log "系统启动完成，开始连接..."
    sleep 3
    log "正在连接中..."
    remmina -c "$REMmina_CONFIG" > /dev/null 2>&1 &
    sleep 3
    log "连接成功，祝您愉快"
fi

