#!/bin/bash

# 配置磁盘变量
DISK="/dev/nvme0n1"   # 请根据你的硬盘设备名称修改此变量

# 设置时间同步
echo ">> Enabling NTP time synchronization"
timedatectl set-ntp true

# 分区磁盘
echo ">> Partitioning disk $DISK"
(
echo g                      # 创建新的 GPT 分区表
echo n                      # 创建新的分区 1 (EFI 分区)
echo 1                      # 分区号
echo                        # 默认起始扇区
echo +1G                    # 大小 1GB
echo n                      # 创建新的分区 2 (根分区)
echo 2
echo
echo +61440M                # 大小 60GB
echo n                      # 创建新的分区 3 (Swap 分区)
echo 3
echo
echo +16384M                # 大小 16GB
echo n                      # 创建新的分区 4 (/home 分区)
echo 4
echo                        # 默认起始扇区
echo                        # 使用剩余所有空间
echo t                      # 修改分区类型
echo 1                      # EFI 分区
echo 1                      # 选择 EFI 系统分区类型
echo t                      # 修改分区类型
echo 3                      # Swap 分区
echo 19                     # 选择 Linux swap 类型
echo w                      # 写入分区表并退出
) | fdisk $DISK

# 格式化分区
echo ">> Formatting partitions"
mkfs.fat -F32 "${DISK}p1"            # EFI分区
mkfs.ext4 "${DISK}p2"                # 根分区
mkfs.ext4 "${DISK}p4"                # /home分区
mkswap "${DISK}p3"                   # Swap分区
swapon "${DISK}p3"                   # 启用Swap

# 配置镜像源
echo ">> Configuring mirrorlist"
echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# 挂载分区
echo ">> Mounting partitions"
mount "${DISK}p2" /mnt
mkdir -p /mnt/home && mount "${DISK}p4" /mnt/home
mkdir -p /mnt/boot && mount "${DISK}p1" /mnt/boot

# 安装基本系统
echo ">> Installing base system"
pacstrap /mnt base base-devel nfs-utils fastfetch picom wakeonlan linux linux-firmware vim dhcpcd zsh git alacritty rofi pipewire pipewire-alsa pipewire-pulse pavucontrol feh noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji numlockx fcitx5 fcitx5-rime fcitx5-configtool rsync mpd mpc openssh polkit mpv libnotify p7zip ranger ntfs-3g

# 生成 fstab
echo ">> Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# 进入 chroot 环境
echo ">> Entering chroot environment"
arch-chroot /mnt /bin/bash <<EOF

# 设置时区
echo ">> Setting timezone"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 配置本地化
echo ">> Configuring localization"
echo -e "en_US.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 网络配置
echo ">> Configuring network"
echo "huai" > /etc/hostname
echo -e "127.0.0.1       localhost\n::1             localhost\n127.0.0.1       huai.localdomain  huai" > /etc/hosts
echo "10.10.10.21:/mnt/user/data /home/huai/data nfs _netdev,noauto,x-systemd.automount,x-systemd.mount-timeout=10,timeo=14,x-systemd.idle-timeout=1min 0 0" >> /etc/fstab

# 设置 root 密码
echo ">> Setting root password"
passwd   # 提示用户在此输入 root 密码

# 安装引导程序和 CPU 微码
echo ">> Installing GRUB bootloader and CPU microcode"
pacman -S --noconfirm grub efibootmgr intel-ucode os-prober

# 配置 GRUB
echo ">> Configuring GRUB"
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# 添加新用户并设置密码
echo ">> Adding new user 'huai'"
useradd -m -G wheel huai
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo ">> Setting password for user 'huai'"
passwd huai   # 提示用户在此输入 huai 用户密码

# 安装 yay
echo ">> Installing yay (AUR helper)"
su - huai -c "cd ~ && git clone https://aur.archlinux.org/yay.git && mkdir data"

EOF

# 退出并重启
echo ">> Exiting chroot and rebooting"
umount -R /mnt
reboot

