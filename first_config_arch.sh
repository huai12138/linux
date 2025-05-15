#!/bin/bash

echo "===== Starting Arch Linux initial configuration ====="

# System-level configuration (first priority)
echo "Setting up system services..."
echo "   Enabling network time synchronization..."
sudo timedatectl set-ntp true
echo "System services configuration completed."
sleep 1
echo "Installing fonts..."
echo "   Creating fonts directory and copying Meslo LG Nerd Font..."
sudo mkdir -p /usr/local/share/fonts && sudo cp -r ~/linux/MesloLGNerdFont /usr/local/share/fonts && fc-cache -fv
echo "Font installation completed."
sleep 1
echo "Setting up numlock..."
echo "   Running numlock configuration script..."
cd ~/linux/numlock && /bin/bash numlock.sh
echo "Numlock setup completed."
sleep 1
# User configuration and environment (medium priority)
echo "Copying configuration files..."
echo "   Copying .config directory to home folder..."
cp -r ~/linux/.config ~ 

echo "   Copying .bashrc to home folder..."

cp ~ /linux/.bashrc ~
echo "   Copying .bashrc to home folder..."

echo "Configuration files copied successfully."
sleep 1


echo "Setting up user services..."
echo "   Enabling and starting Music Player Daemon (MPD)..."
systemctl --user enable mpd --now
echo "User services configuration completed."
sleep 1
# Tools configuration (important but lower priority)
echo "Configuring SSH..."
echo "   Copying SSH key and setting appropriate permissions..."
cp ~/data/linux/.ssh/id_ed25519 ~/.ssh/ && sudo chmod 600 ~/.ssh/id_ed25519
echo "SSH configuration completed."
sleep 1
echo "Configuring Git settings..."
git config --global core.editor "vim" # set vim as default editor
echo "   Setting Git editor to vim..."
git config --global user.email "huai12138@hotmail.com" # git config --global user.email "youremail"
echo "   Setting Git email address..."
git config --global user.name "huai12138"  # git config --global user.name "yourname"
echo "   Setting Git username..."
echo "Git configuration completed."
sleep 1
# Data synchronization (last step)
echo "Syncing media files from data partition..."
echo "   Syncing Music directory..."
rsync -avzh --delete ~/data/media/downloads/Music/ ~/Music 
echo "   Syncing Pictures directory..."
rsync -avzh --delete ~/data/media/downloads/Pictures/ ~/Pictures
echo "File synchronization completed."
sleep 1
echo "All configurations completed successfully!"
sleep 1
echo "===== Arch Linux initial configuration completed ====="
sleep 1