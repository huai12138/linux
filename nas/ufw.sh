# Description: This script is used to configure the ufw firewall on the host machine.
# !/bin/bash
sudo ufw allow from 10.0.0.15 to any port 22 
sudo ufw allow from 10.0.0.15 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.15 to any port 139,445 proto tcp
sudo ufw allow from 10.0.0.8 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.8 to any port 139,445 proto tcp
sudo ufw allow in on docker0

