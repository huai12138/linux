#!/bin/bash
# Auto-start applications for River WM
sleep 1 && fcitx5 -d &
dunst &
waybar &
swww-daemon &
sh /home/huai/.config/swww_auto.sh &
sh /home/huai/.config/shutdown.sh &
zen-browser &
Telegram &