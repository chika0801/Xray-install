#!/usr/bin/env bash
clear
#
wget -qO /usr/share/keyrings/nginx-archive-keyring.key https://nginx.org/keys/nginx_signing.key
#
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.key] https://nginx.org/packages/mainline/debian/ bullseye nginx" > /etc/apt/sources.list.d/sources.list
#
apt update -y
#
apt install -y nginx
#
mkdir -p /etc/systemd/system/nginx.service.d
#
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
#
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
#
chown -R nobody:nogroup /etc/ssl/private/
#
wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/tool/main/nginx.conf
#
wget -qO /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/tool/main/config.json
#
wget -qO /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
#
wget -qO /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
#
