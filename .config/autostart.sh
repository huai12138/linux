#!/bin/bash
play ~/.config/dunst/xp.wav &
# 检查是否安装了 Firefox
if which firefox >/dev/null 2>&1; then
    firefox &
else
    chromium &
fi

telegram-desktop &
/bin/bash  ~/.config/wallpaperautochange.sh &
/bin/bash  ~/.config/dwm_status.sh &
/bin/bash  ~/.config/limit.sh &
#/bin/bash ~/.config/startwindows.sh 
#sleep 20 
#/bin/bash ~/.config/windows.sh
numlockx &
picom -b
fcitx5 -d
dunst &
