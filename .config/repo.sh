#!/bin/bash

# Check if reflector is installed
if ! command -v reflector &> /dev/null; then
    echo "reflector is not installed, installing..."
    sudo pacman -S --noconfirm reflector
fi

# Update mirror list
sudo reflector --country China --age 12 --protocol https --sort rate --score 3 --save /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
