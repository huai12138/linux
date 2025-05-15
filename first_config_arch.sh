#!/bin/bash

# Show messages in English
echo "Configuring Git settings..."
git config --global core.editor "vim" # set vim as default editor
git config --global user.email "huai12138@hotmail.com" # git config --global user.email "youremail"
git config --global user.name "huai12138"  # git config --global user.name "yourname"

echo "Installing fonts..."
sudo mkdir -p /usr/local/share/fonts && sudo cp -r ~/linux/MesloLGNerdFont /usr/local/share/fonts && fc-cache -fv

echo "Copying configuration files..."
cp -r ~/linux/.config ~ 

echo "Setting up numlock..."
cd ~/linux/numlock && /bin/bash numlock.sh

echo "Configuring SSH..."
cp ~/data/linux/.ssh/id_ed25519 ~/.ssh/ && sudo chmod 600 ~/.ssh/id_ed25519

echo "All configurations completed successfully!"

rsync -avzh --delete ~/data/media/downloads/Music/ ~/Music && rsync -avzh --delete ~/data/media/downloads/Pictures/ ~/Pictures
