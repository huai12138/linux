#
# ~/.bashrc
#
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias x="startx"
alias P="shutdown now"
alias R="systemctl reboot"
alias windows="sh /home/huai/.config/windows.sh"
alias np="sh /home/huai/.config/wallpaperchange.sh"
alias 0="pactl set-default-sink alsa_output.usb-DeSheng_Electronics_Inc._Star_Y360-00.analog-stereo"
alias 1="pactl set-default-sink alsa_output.usb-Generic_USB2.0_Device_20130100ph0-00.analog-stereo"
alias volup="pactl set-sink-volume @DEFAULT_SINK@ +10%"
alias voldown="pactl set-sink-volume @DEFAULT_SINK@ -10%"
alias volmute="pactl set-sink-mute @DEFAULT_SINK@ toggle"
alias s="mpc stop"
alias p="mpc play"
alias pause="mpc pause"
alias n="mpc next"
alias pl="vim /home/huai/.config/mpd/playlists/all.m3u"
alias h="Hyprland"
alias config="cd /home/huai/.config"
alias free="cd /home/huai/free"
alias linux="cd /home/huai/linux"
alias stacks="cd /home/huai/stacks"
alias data="cd /home/huai/data"
alias usb="cd /home/huai/usb"
alias www="cd /home/huai/data/www"
alias picomconfig="vim ~/.config/picom.conf"
alias singbox="cd /home/huai/data/appdata/singbox"
alias nas="ssh huai@nas"
alias openwrt="ssh root@openwrt"
alias ax6s="ssh root@ax6s"
alias c="clear"
alias clash="cd /home/huai/data/appdata/clash"
PS1='\[\e[1;32m\]\h\[\e[0m\] \u:\w\$ '

