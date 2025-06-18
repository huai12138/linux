# Description: This script is used to configure the ufw firewall on the host machine.
#!/bin/bash

# 重置防火墙规则
sudo ufw reset

# SSH 访问
sudo ufw allow from 192.168.1.25 to any port 22/tcp

# Samba UDP 端口
sudo ufw allow from 192.168.1.15 to any port 137/udp
sudo ufw allow from 192.168.1.15 to any port 138/udp
sudo ufw allow from 192.168.1.8 to any port 137/udp
sudo ufw allow from 192.168.1.8 to any port 138/udp

# Samba TCP 端口
sudo ufw allow from 192.168.1.15 to any port 139/tcp
sudo ufw allow from 192.168.1.15 to any port 445/tcp
sudo ufw allow from 192.168.1.8 to any port 139/tcp
sudo ufw allow from 192.168.1.8 to any port 445/tcp

# Docker/Podman 网络
sudo ufw allow in on podman0

# HTTP 和 HTTPS 端口
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# NFSv4 端口
sudo ufw allow from 192.168.1.25 to any port 111/tcp    # rpcbind TCP
sudo ufw allow from 192.168.1.25 to any port 111/udp    # rpcbind UDP
sudo ufw allow from 192.168.1.25 to any port 2049/tcp   # NFSv4 主端口
sudo ufw allow from 192.168.1.25 to any port 20049/tcp  # NFS RDMA 端口

# Podman 容器 TCP 端口
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

# Podman 容器 UDP 端口
sudo ufw allow 1900/udp
sudo ufw allow 5353/udp
sudo ufw allow 6888/udp

