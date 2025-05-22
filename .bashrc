#
# ~/.bashrc
#
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# 系统操作
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c="clear"
alias x="startx"
alias P="sleep 300 && shutdown now"
alias R="systemctl reboot"
alias update="sudo pacman -Syyu"
alias rsyncdir="rsync -avzh --delete"  # 同步目录，删除目标端多余文件

# 配置文件编辑
alias bashconfig="vim ~/.bashrc"



# 目录导航
alias cdconfig="cd /home/huai/.config"
alias cdlinux="cd /home/huai/linux"
alias cdstacks="cd /home/huai/stacks"
alias cddata="cd /home/huai/data"
alias cdappdata="cd /home/huai/data/appdata"
alias cdusb="cd /home/huai/usb"
alias cdwww="cd /home/huai/data/www"
alias cdfree="cd /home/huai/free"
alias cdclash="cd /home/huai/data/appdata/clash"
alias ..='cd ..'
alias ~='cd ~'

# 音频控制
alias audio0="pactl set-default-sink alsa_output.usb-DeSheng_Electronics_Inc._Star_Y360-00.analog-stereo"
alias audio1="pactl set-default-sink alsa_output.usb-Generic_USB2.0_Device_20130100ph0-00.analog-stereo"
alias vol='pactl set-sink-volume @DEFAULT_SINK@'
alias volup="pactl set-sink-volume @DEFAULT_SINK@ +10%"
alias voldown="pactl set-sink-volume @DEFAULT_SINK@ -10%"
alias volmute="pactl set-sink-mute @DEFAULT_SINK@ toggle"

# MPD控制
alias mstop="mpc stop"
alias mplay="mpc play"
alias mnext="mpc next"
alias mpause="mpc pause"
alias mpl="vim /home/huai/.config/mpd/playlists/all.m3u"

# 远程连接
alias nas="ssh admin@10.0.0.21"
alias cloud="ssh root@ssh.202309.xyz"
alias openwrt="ssh root@10.0.0.1"
alias ax6s="ssh root@10.0.0.2"

# 脚本和程序
alias hypr="Hyprland"
alias win="sh /home/huai/.config/windows.sh"
alias np="sh /home/huai/.config/swww.sh"
alias repo="sh /home/huai/.config/repo.sh"
mc() {
    /bin/bash "$(ls ~/Downloads/HMCL-*.sh | head -n 1)"
}


# Git相关
alias gaa='git add --all'
alias gc='git commit -v'
alias ggpush='git push origin main'

PS1='\[\e[1;32m\]\h\[\e[0m\] \u:\w\$ '
export LANG=en_US.UTF-8
export VISUAL=vim
export EDITOR=vim
export TERM=xterm-256color
