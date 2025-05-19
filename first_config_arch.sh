#!/bin/bash

# Define colors for better output visualization
GREEN='\033[0;32m'    # Success messages
YELLOW='\033[1;33m'   # Warnings
RED='\033[0;31m'      # Errors
BLUE='\033[0;34m'     # Section titles
CYAN='\033[0;36m'     # Operation details
NC='\033[0m'          # Reset color

echo -e "${BLUE}===== Starting Arch Linux initial configuration =====${NC}"

# System-level configuration (first priority)
echo -e "${BLUE}Setting up system services...${NC}"
echo -e "${CYAN}   Enabling network time synchronization...${NC}"
sudo timedatectl set-ntp true
echo -e "${GREEN}System services configuration completed.${NC}"
sleep 3

echo -e "${BLUE}Installing fonts...${NC}"
echo -e "${CYAN}   Creating fonts directory and copying Meslo LG Nerd Font...${NC}"
sudo mkdir -p /usr/local/share/fonts && sudo cp -r ~/linux/MesloLGNerdFont /usr/local/share/fonts && fc-cache -fv
echo -e "${GREEN}Font installation completed.${NC}"
sleep 3

echo -e "${BLUE}Setting up numlock...${NC}"
echo -e "${CYAN}   Running numlock configuration script...${NC}"
cd ~/linux/numlock && /bin/bash numlock.sh
echo -e "${GREEN}Numlock setup completed.${NC}"
sleep 3

# User configuration and environment (medium priority)
echo -e "${BLUE}Copying configuration files...${NC}"
echo -e "${CYAN}   Copying .config directory to home folder...${NC}"
cp -r ~/linux/.config ~ 
echo -e "${CYAN}   Copying .bashrc to home folder...${NC}"
cp ~/linux/.bashrc ~
echo -e "${GREEN}Configuration files copied successfully.${NC}"
sleep 3

echo -e "${BLUE}Setting up user services...${NC}"
echo -e "${CYAN}   Enabling and starting Music Player Daemon (MPD)...${NC}"
systemctl --user enable mpd --now
echo -e "${GREEN}User services configuration completed.${NC}"
sleep 3

# Tools configuration (important but lower priority)
echo -e "${BLUE}Configuring SSH...${NC}"
echo -e "${CYAN}   Copying SSH key and setting appropriate permissions...${NC}"
mkdir -p ~/.ssh && cp ~/data/linux/.ssh/id_ed25519 ~/.ssh && cd ~/.ssh && chmod 600 id_ed25519
echo -e "${GREEN}SSH configuration completed.${NC}"
sleep 3

echo -e "${BLUE}Configuring Git settings...${NC}"
echo -e "${CYAN}   Setting Git editor to vim...${NC}"
git config --global core.editor "vim" # set vim as default editor
sleep 3

# Read Git information from config file
if [ -f ~/data/linux/github.txt ]; then
    # Read email
    GIT_EMAIL=$(grep "EMAIL=" ~/data/linux/github.txt | cut -d= -f2)
    if [ -n "$GIT_EMAIL" ]; then
        git config --global user.email "$GIT_EMAIL"
        echo -e "${CYAN}   Setting Git email from config file...${NC}"
        sleep 3
    else
        echo -e "${YELLOW}   Warning: Could not find EMAIL in config file${NC}"
        sleep 3
    fi
    
    # Read username
    GIT_USERNAME=$(grep "USERNAME=" ~/data/linux/github.txt | cut -d= -f2)
    if [ -n "$GIT_USERNAME" ]; then
        git config --global user.name "$GIT_USERNAME"
        echo -e "${CYAN}   Setting Git username from config file...${NC}"
        sleep 3
    else
        echo -e "${YELLOW}   Warning: Could not find USERNAME in config file${NC}"
        sleep 3
    fi
    
    # Only show completion message if both settings were applied
    if [ -n "$GIT_EMAIL" ] && [ -n "$GIT_USERNAME" ]; then
        echo -e "${GREEN}Git configuration completed successfully.${NC}"
        sleep 3
    else
        echo -e "${YELLOW}Git configuration incomplete. Check your config file.${NC}"
        sleep 3
    fi
else
    echo -e "${YELLOW}   Warning: Git config file not found at ~/data/linux/github.txt${NC}"
    echo -e "${YELLOW}   Skipping Git user configuration.${NC}"
    sleep 3
fi

# Data synchronization (last step)
echo -e "${BLUE}Syncing media files from data partition...${NC}"
echo -e "${CYAN}   Syncing Music directory...${NC}"
rsync -avzh --delete ~/data/media/downloads/Music/ ~/Music 
echo -e "${CYAN}   Syncing Pictures directory...${NC}"
rsync -avzh --delete ~/data/media/downloads/Pictures/ ~/Pictures
echo -e "${GREEN}File synchronization completed.${NC}"
sleep 3

echo -e "${GREEN}All configurations completed successfully!${NC}"
sleep 3
echo -e "${BLUE}===== Arch Linux initial configuration completed =====${NC}"
sleep 3
