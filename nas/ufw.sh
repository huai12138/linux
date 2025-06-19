# Description: This script is used to configure the ufw firewall on the host machine.
#!/bin/bash

# 重置防火墙规则
sudo ufw reset

# SSH 访问
sudo ufw allow proto tcp from 192.168.8.25 to any port 22

# Samba UDP 端口
sudo ufw allow proto udp from 192.168.8.15 to any port 137
sudo ufw allow proto udp from 192.168.8.15 to any port 138
sudo ufw allow proto udp from 192.168.8.8 to any port 137
sudo ufw allow proto udp from 192.168.8.8 to any port 138

# Samba TCP 端口
sudo ufw allow proto tcp from 192.168.8.15 to any port 139
sudo ufw allow proto tcp from 192.168.8.15 to any port 445
sudo ufw allow proto tcp from 192.168.8.8 to any port 139
sudo ufw allow proto tcp from 192.168.8.8 to any port 445

# Docker/Podman 网络
sudo ufw allow in on podman0

# HTTP 和 HTTPS 端口
sudo ufw allow proto tcp to any port 80    # HTTP
sudo ufw allow proto tcp to any port 443   # HTTPS

# NFSv4 端口
sudo ufw allow proto tcp from 192.168.8.25 to any port 111    # rpcbind TCP
sudo ufw allow proto udp from 192.168.8.25 to any port 111    # rpcbind UDP
sudo ufw allow proto tcp from 192.168.8.25 to any port 2049   # NFSv4 主端口
sudo ufw allow proto tcp from 192.168.8.25 to any port 20049  # NFS RDMA 端口

# Podman 容器 TCP 端口
sudo ufw allow proto tcp to any port 8096
sudo ufw allow proto tcp to any port 5000
sudo ufw allow proto tcp to any port 6800
sudo ufw allow proto tcp to any port 6888
sudo ufw allow proto tcp to any port 6880
sudo ufw allow proto tcp to any port 5008
sudo ufw allow proto tcp to any port 8083
sudo ufw allow proto tcp to any port 4000
sudo ufw allow proto tcp to any port 5900
sudo ufw allow proto tcp to any port 8181
sudo ufw allow proto tcp to any port 5002
sudo ufw allow proto tcp to any port 8002
sudo ufw allow proto tcp to any port 3001
sudo ufw allow proto tcp to any port 8123
sudo ufw allow proto tcp to any port 6065
sudo ufw allow proto tcp to any port 8081

# Podman 容器 UDP 端口
sudo ufw allow proto udp to any port 1900
sudo ufw allow proto udp to any port 5353
sudo ufw allow proto udp to any port 6888

