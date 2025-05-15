#!/bin/bash

echo "===== Starting Arch Linux initial configuration ====="

# Show messages in English
echo "Configuring Git settings..."
git config --global core.editor "vim" # set vim as default editor
echo "   Setting Git editor to vim..."
git config --global user.email "huai12138@hotmail.com" # git config --global user.email "youremail"
echo "   Setting Git email address..."
git config --global user.name "huai12138"  # git config --global user.name "yourname"
echo "   Setting Git username..."
echo "Git configuration completed."

echo "Installing fonts..."
echo "   Creating fonts directory and copying Meslo LG Nerd Font..."
sudo mkdir -p /usr/local/share/fonts && sudo cp -r ~/linux/MesloLGNerdFont /usr/local/share/fonts && fc-cache -fv
echo "Font installation completed."

echo "Copying configuration files..."
echo "   Copying .config directory to home folder..."
cp -r ~/linux/.config ~ 
echo "Configuration files copied successfully."

echo "Setting up numlock..."
echo "   Running numlock configuration script..."
cd ~/linux/numlock && /bin/bash numlock.sh
echo "Numlock setup completed."

echo "Configuring SSH..."
echo "   Copying SSH key and setting appropriate permissions..."
cp ~/data/linux/.ssh/id_ed25519 ~/.ssh/ && sudo chmod 600 ~/.ssh/id_ed25519
echo "SSH configuration completed."
systemctl --user enable mpd --now
echo "All configurations completed successfully!"

echo "Syncing media files from data partition..."
echo "   Syncing Music directory..."
rsync -avzh --delete ~/data/media/downloads/Music/ ~/Music 
echo "   Syncing Pictures directory..."
rsync -avzh --delete ~/data/media/downloads/Pictures/ ~/Pictures
echo "File synchronization completed."

echo "===== Arch Linux initial configuration completed ====="
