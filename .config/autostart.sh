#!/bin/bash
play ~/.config/dunst/xp.wav &
start="firefox"
if [ "$start" = "firefox" ]; then
	firefox &
else
	chromium &
fi	
telegram-desktop &
/bin/bash  ~/.config/wallpaperautochange.sh &
/bin/bash  ~/.config/limit.sh &
#/bin/bash ~/.config/startwindows.sh 
#sleep 20 
#/bin/bash ~/.config/windows.sh
numlockx &
picom -b
fcitx5 -d
dunst &
sleep 5	
/bin/bash  ~/.config/dwm_status.sh &
