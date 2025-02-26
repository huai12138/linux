#
# ~/.bashrc
#
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias x='startx'
alias P='sudo shutdown now'
alias R='sudo systemctl reboot'
alias windows='sh /home/huai/.config/windows.sh'
alias xlg='~/.steam/steamapps/common/Stardew\ Valley/StardewValley > /dev/null 2>&1'
alias np='sh /home/huai/.config/wallpaperchange.sh'
alias repo='sh /home/huai/.config/repo.sh'
alias nm='mpc next'
alias 0='pactl set-default-sink alsa_output.usb-DeSheng_Electronics_Inc._Star_Y360-00.analog-stereo'
alias 1='pactl set-default-sink alsa_output.usb-Generic_USB2.0_Device_20130100ph0-00.analog-stereo'
alias vol='pactl set-sink-volume @DEFAULT_SINK@'
alias volup='pactl set-sink-volume @DEFAULT_SINK@ +10%'
alias voldown='pactl set-sink-volume @DEFAULT_SINK@ -10%'
alias volmute='pactl set-sink-mute @DEFAULT_SINK@ toggle'
alias s='mpc stop'
alias p='mpc play'
alias pause='mpc pause'
alias pl='vim /home/huai/.config/mpd/playlists/all.m3u'
alias h='Hyprland'
alias config='cd /home/huai/.config'
alias free='cd /home/huai/free'
alias linux='cd /home/huai/linux'
alias stacks='cd /home/huai/stacks'
alias data='cd /home/huai/data'
alias usb='cd /home/huai/usb'
alias www='cd /home/huai/data/www'
alias picomconfig='vim ~/.config/picom.conf'
alias singbox='cd /home/huai/data/appdata/singbox'
alias appdata='cd /home/huai/data/appdata'
alias nas='ssh huai@nas'
alias openwrt='ssh root@openwrt'
alias ax6s='ssh root@ax6s'
alias c='clear'
alias clash='cd /home/huai/data/appdata/clash'
alias gaa='git add --all'
alias gc='git commit -v'
alias ggpush='git push origin main'
alias ..='cd ..'
alias ~='cd ~'
PS1='\[\e[1;32m\]\h\[\e[0m\] \u:\w\$ '
