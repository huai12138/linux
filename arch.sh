#!/bin/bash

# 添加错误处理函数
set -e  # 任何命令失败立即退出
error_handler() {
    echo "错误发生在第 $1 行"
    exit 1
}
trap 'error_handler ${LINENO}' ERR

# 配置磁盘变量
DISK="/dev/nvme0n1"   # 请根据你的硬盘设备名称修改此变量

# 在脚本开始处添加硬盘设备检查
if [ ! -b "$DISK" ]; then
    echo "错误：设备 $DISK 不存在"
    exit 1
fi

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
echo +512m                  # 大小 512m
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

# 检查并安装 reflector
echo ">> Checking and installing reflector"
if ! command -v reflector &> /dev/null; then
    echo "reflector 未安装，正在安装..."
    pacman -S --noconfirm reflector
fi

# 更新镜像列表
echo ">> Updating mirror list"
reflector --country China --age 12 --protocol https --sort rate --score 5 --save /etc/pacman.d/mirrorlist

# 挂载分区
echo ">> Mounting partitions"
mount "${DISK}p2" /mnt
mkdir -p /mnt/home && mount "${DISK}p4" /mnt/home
mkdir -p /mnt/boot && mount "${DISK}p1" /mnt/boot

# 安装基本系统
echo ">> Installing base system"
pacstrap /mnt base base-devel nfs-utils fastfetch picom wakeonlan linux linux-firmware vim dhcpcd git alacritty rofi pipewire pipewire-alsa pipewire-pulse pavucontrol feh noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji numlockx fcitx5 fcitx5-rime fcitx5-configtool rsync mpd mpc openssh polkit libnotify p7zip ranger ntfs-3g xorg xorg-server xorg-xinit remmina freerdp curl xf86-video-intel libva libva-intel-driver vlc arp-scan unzip firefox ttf-liberation dunst

# 生成 fstab
echo ">> Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab
# 获取根分区的 UUID
ROOT_UUID=$(blkid -s UUID -o value "${DISK}p2")
# 在 chroot 环境中执行命令
echo ">> Entering chroot environment"
arch-chroot /mnt env ROOT_UUID="$ROOT_UUID" /bin/bash -c '
echo "The root UUID is: $ROOT_UUID"
sleep 10

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 配置本地化
echo -e "en_US.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 网络配置
echo "huai" > /etc/hostname
echo -e "127.0.0.1       localhost\n::1             localhost\n127.0.0.1       huai.localdomain  huai" > /etc/hosts
echo "10.0.0.21:/mnt/user/data /home/huai/data nfs _netdev,noauto,x-systemd.automount,x-systemd.mount-timeout=10,timeo=14,x-systemd.idle-timeout=1min 0 0" >> /etc/fstab

# 设置 root 密码
echo "root:1" | chpasswd

# 安装引导程序和 CPU 微码
pacman -S --noconfirm efibootmgr intel-ucode

# 安装 systemd-boot
bootctl install --path=/boot

# 配置 loader
echo ">> Setting up loader configuration"
echo "default arch.conf" > /boot/loader/loader.conf
echo "# timeout 5" >> /boot/loader/loader.conf
echo "# editor no" >> /boot/loader/loader.conf

# 配置 systemd-boot
echo "title   Arch Linux" > /boot/loader/entries/arch.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=UUID=$ROOT_UUID rw quiet" >> /boot/loader/entries/arch.conf

# 添加新用户并设置密码
useradd -m -G wheel huai
echo "huai ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "huai:1" | chpasswd

# 配置输入法环境变量
echo -e "GTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx\nSDL_IM_MODULE=fcitx\nGLFW_IM_MODULE=fcitx" >> /etc/environment

# 安装 yay
su - huai -c "cd ~ && git clone https://aur.archlinux.org/yay.git && mkdir data"
systemctl enable sshd dhcpcd
'

# 清理并重启
echo ">> Cleaning up and rebooting"
umount -R /mnt
reboot

