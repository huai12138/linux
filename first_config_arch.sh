#!/bin/bash

# Define colors for better output visualization
GREEN='\033[0;32m'    # Success messages
YELLOW='\033[1;33m'   # Warnings
RED='\033[0;31m'     # Errors
BLUE='\033[0;34m'     # Section titles
CYAN='\033[0;36m'     # Operation details
NC='\033[0m'          # Reset color

# Error handling function
handle_error() {
    echo -e "${RED}Error: $1${NC}"
    echo -e "${YELLOW}Configuration may be incomplete. Check the error and try again.${NC}"
    sleep 5  # Sleep 5 seconds after error message
}

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        handle_error "$1"
        return 1
    fi
    return 0
}

# Trap to handle script interruption
trap 'echo -e "${RED}Script interrupted. Configuration may be incomplete.${NC}"; sleep 5; exit 1' INT TERM

echo -e "${BLUE}===== Starting Arch Linux initial configuration =====${NC}"
sleep 1

# System-level configuration (first priority)
echo -e "${BLUE}Setting up system services...${NC}"
echo -e "${CYAN}   Enabling network time synchronization...${NC}"
sudo timedatectl set-ntp true
if ! check_command "Failed to enable network time synchronization"; then
    echo -e "${YELLOW}   Continuing with configuration despite the error...${NC}"
    sleep 3  # Sleep 3 seconds after warning message
fi
echo -e "${GREEN}System services configuration completed.${NC}"
sleep 1  # Sleep 1 second after success message

echo -e "${BLUE}Installing yay AUR ...${NC}"
if command -v yay >/dev/null 2>&1; then
    echo -e "${GREEN}yay is already installed.${NC}"
    sleep 1  # Sleep 1 second after success message
else
    echo -e "${CYAN}   Building and installing yay...${NC}"
    
    # Check if yay directory exists
    if [ ! -d ~/yay ]; then
        echo -e "${CYAN}   Cloning yay repository...${NC}"
        cd ~ && git clone https://aur.archlinux.org/yay.git
        check_command "Failed to clone yay repository"
    fi
    
    # Enter directory and build/install
    cd ~/yay || { handle_error "Cannot navigate to yay directory"; echo -e "${YELLOW}   Skipping yay installation...${NC}"; sleep 3; }
    
    makepkg -si --noconfirm
    check_command "Failed to build and install yay"
    
    # Return to original directory
    cd ~ || handle_error "Cannot navigate back to home directory"
    
    echo -e "${GREEN}yay installation completed.${NC}"
    sleep 1  # Sleep 1 second after success message
fi

echo -e "${BLUE}Installing fonts...${NC}"
echo -e "${CYAN}   Creating fonts directory and copying Meslo LG Nerd Font...${NC}"
sudo mkdir -p /usr/local/share/fonts
check_command "Failed to create fonts directory"

if [ -d ~/linux/MesloLGNerdFont ]; then
    sudo cp -r ~/linux/MesloLGNerdFont /usr/local/share/fonts
    check_command "Failed to copy font files"
    
    fc-cache -fv
    check_command "Failed to update font cache"
    echo -e "${GREEN}Font installation completed.${NC}"
    sleep 1  # Sleep 1 second after success message
else
    echo -e "${YELLOW}   Warning: MesloLGNerdFont directory not found${NC}"
    sleep 3  # Sleep 3 seconds after warning message
fi

echo -e "${BLUE}Setting up numlock...${NC}"
echo -e "${CYAN}   Running numlock configuration script...${NC}"
if [ -d ~/linux/numlock ]; then
    cd ~/linux/numlock || { handle_error "Cannot navigate to numlock directory"; echo -e "${YELLOW}   Skipping numlock setup...${NC}"; sleep 3; }
    
    if [ -f ./numlock.sh ]; then
        bash ./numlock.sh
        check_command "Numlock script encountered an error"
    else
        handle_error "Numlock script not found"
    fi
else
    echo -e "${YELLOW}   Warning: numlock directory not found, skipping...${NC}"
    sleep 3  # Sleep 3 seconds after warning message
fi
echo -e "${GREEN}Numlock setup completed.${NC}"
sleep 1  # Sleep 1 second after success message

# User configuration and environment (medium priority)
echo -e "${BLUE}Select window manager${NC}"
echo -e "${CYAN}1) dwm${NC}"
echo -e "${CYAN}2) hyprland${NC}"
read -p "Enter your choice (1 or 2): " wm_choice

if [ "$wm_choice" = "1" ]; then
    echo -e "${GREEN}You selected dwm.${NC}"
    # Copy .config_x11 to ~/.config
    if [ -d ~/linux/.config_x11 ]; then
        cp -r ~/linux/.config_x11 ~/.config
        check_command "Failed to copy .config_x11"
        echo -e "${GREEN}.config_x11 copied to ~/.config${NC}"
    else
        echo -e "${YELLOW}~/linux/.config_x11 not found, skipping copy${NC}"
    fi
    # Copy .xinit to ~
    if [ -f ~/linux/.xinit ]; then
        cp ~/linux/.xinit ~
        check_command "Failed to copy .xinit"
        echo -e "${GREEN}.xinit copied to ~${NC}"
    else
        echo -e "${YELLOW}~/linux/.xinit not found, skipping copy${NC}"
    fi
    skip_config_copy=true
else
    echo -e "${GREEN}You selected hyprland.${NC}"
    skip_config_copy=false
fi

echo -e "${BLUE}Copying configuration files...${NC}"
echo -e "${CYAN}   Copying .config directory to home folder...${NC}"
if [ "$skip_config_copy" = true ]; then
    echo -e "${CYAN}   dwm selected, skipping .config copy.${NC}"
else
    if [ -d ~/linux/.config ]; then
        cp -r ~/linux/.config ~
        check_command "Failed to copy .config directory"
    else
        echo -e "${YELLOW}   Warning: .config directory not found in ~/linux/${NC}"
        sleep 3
    fi
fi

echo -e "${CYAN}   Copying .bashrc to home folder...${NC}"
if [ -f ~/linux/.bashrc ]; then
    cp ~/linux/.bashrc ~
    check_command "Failed to copy .bashrc"
else
    echo -e "${YELLOW}   Warning: .bashrc not found in ~/linux/${NC}"
    sleep 3
fi
echo -e "${GREEN}Configuration files copied successfully.${NC}"
sleep 1

echo -e "${BLUE}Setting up user services...${NC}"
echo -e "${CYAN}   Enabling and starting Music Player Daemon (MPD)...${NC}"
systemctl --user enable mpd --now
if ! check_command "Failed to enable/start MPD service"; then
    echo -e "${YELLOW}   MPD service may not be installed or may have failed to start${NC}"
    echo -e "${YELLOW}   Continuing with configuration...${NC}"
    sleep 3  # Sleep 3 seconds after warning message
fi
echo -e "${GREEN}User services configuration completed.${NC}"
sleep 1  # Sleep 1 second after success message

# Tools configuration (important but lower priority)
echo -e "${BLUE}Configuring SSH...${NC}"
echo -e "${CYAN}   Copying SSH key and setting appropriate permissions...${NC}"
mkdir -p ~/.ssh
check_command "Failed to create ~/.ssh directory"

if [ -f ~/data/linux/.ssh/id_ed25519 ]; then
    cp ~/data/linux/.ssh/id_ed25519 ~/.ssh/
    check_command "Failed to copy SSH key"
    
    cd ~/.ssh || { handle_error "Cannot navigate to ~/.ssh directory"; }
    chmod 600 id_ed25519
    check_command "Failed to set permissions on SSH key"
    echo -e "${GREEN}SSH configuration completed.${NC}"
    sleep 1  # Sleep 1 second after success message
else
    echo -e "${YELLOW}   Warning: SSH key not found at ~/data/linux/.ssh/id_ed25519${NC}"
    echo -e "${YELLOW}   SSH configuration incomplete.${NC}"
    sleep 3  # Sleep 3 seconds after warning message
fi

echo -e "${BLUE}Configuring Git settings...${NC}"
echo -e "${CYAN}   Setting Git editor to vim...${NC}"
if command -v git >/dev/null 2>&1; then
    git config --global core.editor "vim" # set vim as default editor
    check_command "Failed to set Git editor"
else
    echo -e "${YELLOW}   Warning: Git is not installed, skipping Git configuration...${NC}"
    sleep 3  # Sleep 3 seconds after warning message
    # Skip the rest of Git configuration if Git is not installed
    goto_data_sync=true
fi

if [ "$goto_data_sync" != "true" ]; then
    # Read Git information from config file
    if [ -f ~/data/linux/github.config ]; then
        # Read email
        GIT_EMAIL=$(grep "EMAIL=" ~/data/linux/github.config | cut -d= -f2)
        if [ -n "$GIT_EMAIL" ]; then
            git config --global user.email "$GIT_EMAIL"
            check_command "Failed to set Git email"
            echo -e "${CYAN}   Setting Git email from config file...${NC}"
        else
            echo -e "${YELLOW}   Warning: Could not find EMAIL in config file${NC}"
            sleep 3  # Sleep 3 seconds after warning message
        fi
        
        # Read username
        GIT_USERNAME=$(grep "USERNAME=" ~/data/linux/github.config | cut -d= -f2)
        if [ -n "$GIT_USERNAME" ]; then
            git config --global user.name "$GIT_USERNAME"
            check_command "Failed to set Git username"
            echo -e "${CYAN}   Setting Git username from config file...${NC}"
        else
            echo -e "${YELLOW}   Warning: Could not find USERNAME in config file${NC}"
            sleep 3  # Sleep 3 seconds after warning message
        fi
        
        # Only show completion message if both settings were applied
        if [ -n "$GIT_EMAIL" ] && [ -n "$GIT_USERNAME" ]; then
            echo -e "${GREEN}Git configuration completed successfully.${NC}"
            sleep 1  # Sleep 1 second after success message
        else
            echo -e "${YELLOW}Git configuration incomplete. Check your config file.${NC}"
            sleep 3  # Sleep 3 seconds after warning message
        fi
    else
        echo -e "${YELLOW}   Warning: Git config file not found at ~/data/linux/github.config${NC}"
        echo -e "${YELLOW}   Skipping Git user configuration.${NC}"
        sleep 3  # Sleep 3 seconds after warning message
    fi
fi

# Data synchronization (last step)
echo -e "${BLUE}Syncing media files from data partition...${NC}"

# Check if data directory exists
if [ ! -d ~/data/Downloads ]; then
    echo -e "${YELLOW}   Warning: ~/data/Downloads directory not found${NC}"
    echo -e "${YELLOW}   Skipping file synchronization...${NC}"
    sleep 3  # Sleep 3 seconds after warning message
else
    echo -e "${CYAN}   Syncing Music directory...${NC}"
    if [ -d ~/data/Downloads/Music ]; then
        mkdir -p ~/Music
        rsync -avzh --delete ~/data/Downloads/Music/ ~/Music
        check_command "Failed to sync Music directory"
    else
        echo -e "${YELLOW}   Warning: Music directory not found in data partition${NC}"
        sleep 3  # Sleep 3 seconds after warning message
    fi
    
    echo -e "${CYAN}   Syncing Pictures directory...${NC}"
    if [ -d ~/data/Downloads/Pictures ]; then
        mkdir -p ~/Pictures
        rsync -avzh --delete ~/data/Downloads/Pictures/ ~/Pictures
        check_command "Failed to sync Pictures directory"
    else
        echo -e "${YELLOW}   Warning: Pictures directory not found in data partition${NC}"
        sleep 3  # Sleep 3 seconds after warning message
    fi
    echo -e "${GREEN}File synchronization completed.${NC}"
    sleep 1  # Sleep 1 second after success message
fi

echo -e "${GREEN}All configurations completed successfully!${NC}"
sleep 1  # Sleep 1 second after success message
echo -e "${BLUE}===== Arch Linux initial configuration completed =====${NC}"
sleep 1  # Sleep 1 second after final message
