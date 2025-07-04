curl https://get.acme.sh | sh -s email=my@example.com
acme.sh --issue --dns dns_cf -d example.com -d *.example.com


acme.sh --install-cert -d example.com \
--key-file       /mnt/user/data/appdata/nginx/key.pem  \
--fullchain-file /mnt/user/data/appdata/nginx/cert.pem \
--reloadcmd     "sudo nginx -s reload"