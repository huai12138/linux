#!/bin/zsh

chromium &
telegram-desktop &
/bin/zsh ~/.config/wallpaperautochange.sh &
/bin/zsh ~/.config/limit.sh &
#/bin/zsh ~/.config/startwindows.sh 
#sleep 20 
#/bin/zsh ~/.config/windows.sh
dunst & 
