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

# Allow Podman container TCP ports
sudo ufw allow 8096/tcp
sudo ufw allow 5000/tcp
sudo ufw allow 6800/tcp
sudo ufw allow 6888/tcp
sudo ufw allow 6880/tcp
sudo ufw allow 5008/tcp
sudo ufw allow 8083/tcp
sudo ufw allow 4000/tcp
sudo ufw allow 5900/tcp
sudo ufw allow 8181/tcp
sudo ufw allow 5002/tcp
sudo ufw allow 8002/tcp
sudo ufw allow 3001/tcp
sudo ufw allow 8123/tcp
sudo ufw allow 6065/tcp
sudo ufw allow 8081/tcp

# Allow Podman container UDP ports
sudo ufw allow 1900/udp
sudo ufw allow 5353/udp
sudo ufw allow 6888/udp
