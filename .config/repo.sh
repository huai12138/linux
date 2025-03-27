#!/bin/bash

# 检查 reflector 是否已安装
if ! command -v reflector &> /dev/null; then
    echo "reflector 未安装，正在安装..."
    sudo pacman -S --noconfirm reflector
fi

# 更新镜像列表
sudo reflector --country China --age 12 --protocol https --sort rate --score 3 --save /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
