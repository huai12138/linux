#!/bin/bash

# Define color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Reset color

echo -e "${BLUE}===== Starting Secure Boot Configuration =====${NC}"
sleep 3

echo -e "${YELLOW}Creating Secure Boot keys...${NC}"
sudo sbctl create-keys
sleep 3

echo -e "${YELLOW}Enrolling keys to UEFI...${NC}"
sudo sbctl enroll-keys -m 
sleep 3

echo -e "${YELLOW}Signing bootloader file...${NC}"
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sleep 3

echo -e "${YELLOW}Signing systemd-boot...${NC}"
sudo sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
sleep 3

echo -e "${YELLOW}Signing Linux kernel...${NC}"
sudo sbctl sign -s /boot/vmlinuz-linux-lts
sleep 3

echo -e "${YELLOW}Verifying signature status...${NC}"
sudo sbctl verify
sleep 3

echo -e "${YELLOW}Enabling systemd-boot-update service...${NC}"
sudo systemctl enable --now systemd-boot-update
sleep 3

echo -e "${GREEN}Secure Boot configuration completed!${NC}"
sleep 3