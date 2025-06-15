#!/bin/bash
play ~/.config/dunst/xp.wav &
zen-browser &
Telegram &
/bin/bash  ~/.config/wallpaperautochange.sh &
#/bin/bash  ~/.config/limit.sh &
/bin/bash  ~/.config/shutdown.sh &
#/bin/bash ~/.config/startwindows.sh 
#sleep 20 
#/bin/bash ~/.config/windows.sh
numlockx &
picom -b
fcitx5 -d
dunst &
sleep 3	
/bin/bash  ~/.config/dwm_status.sh &
