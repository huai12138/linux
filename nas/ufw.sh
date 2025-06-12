# Description: This script is used to configure the ufw firewall on the host machine.
# !/bin/bash
sudo ufw allow from 10.0.0.25 to any port 22 
sudo ufw allow from 10.0.0.15 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.15 to any port 139,445 proto tcp
sudo ufw allow from 10.0.0.8 to any port 137,138 proto udp
sudo ufw allow from 10.0.0.8 to any port 139,445 proto tcp
sudo ufw allow in on podman0
# HTTP and HTTPS ports
sudo ufw allow 80 proto tcp    # HTTP
sudo ufw allow 443 proto tcp   # HTTPS
# NFSv4 only needs these ports:
sudo ufw allow from 10.0.0.25 to any port 111 proto tcp    # rpcbind TCP (still needed for service discovery)
sudo ufw allow from 10.0.0.25 to any port 111 proto udp    # rpcbind UDP
sudo ufw allow from 10.0.0.25 to any port 2049 proto tcp  # NFSv4 main port
sudo ufw allow from 10.0.0.25 to any port 20049 proto tcp  # NFS RDMA port
# Remove these lines as they are NFSv3 specific:
# sudo ufw allow from 10.0.0.25 to any port 20048 proto tcp  # mountd (NFSv3)
# sudo ufw allow from 10.0.0.25 to any port 32765 proto tcp  # statd (NFSv3)
# sudo ufw allow from 10.0.0.25 to any port 32766 proto tcp  # statd outgoing (NFSv3)
# sudo ufw allow from 10.0.0.25 to any port 32767 proto tcp  # lockd (NFSv3)
# sudo ufw allow from 10.0.0.25 to any port 32768 proto udp  # lockd (NFSv3)
