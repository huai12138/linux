#!/bin/bash

# 替换 sources.list 内容为清华源（Bookworm版本）
echo "正在将 sources.list 替换为清华源 (Bookworm)..."
sudo tee /etc/apt/sources.list > /dev/null <<EOF
# Debian 清华源 (Bookworm)

# 主软件库
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

# 更新源
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

# 软件包更新源
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

# Debian安全更新
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

# 更新软件包列表
echo "正在更新软件包列表..."
sudo apt update

echo "清华源 (Bookworm) 设置完成！"
#安装dwm依赖 
#sudo apt install -y xorg build-essential libx11-dev libxft-dev libxinerama-dev 

echo "安装完成！"
