# Description: This script is used to configure the ufw firewall on the host machine.
# !/bin/bash
sudo ufw allow from 10.0.0.15 to any port 22 
sudo ufw allow from 10.0.0.15 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.15 to any port 139,445 proto tcp
sudo ufw allow from 10.0.0.8 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.8 to any port 139,445 proto tcp
sudo ufw allow in on docker0
sudo ufw allow from 10.0.0.25 to any port 2049 proto tcp  # NFS 默认端口
sudo ufw allow from 10.0.0.25 to any port 20048 proto tcp  # mountd
sudo ufw allow from 10.0.0.25 to any port 32765 proto tcp  # statd
sudo ufw allow from 10.0.0.25 to any port 32766 proto tcp  # statd outgoing
sudo ufw allow from 10.0.0.25 to any port 32767 proto tcp  # lockd
sudo ufw allow from 10.0.0.25 to any port 32768 proto udp  # lockd
