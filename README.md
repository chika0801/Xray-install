## [XTLS Vision](https://github.com/XTLS/Xray-core/discussions/1295) 安装指南

**已有SSL证书**

- 将证书文件改名为 **fullchain.cer**，将私钥文件改名为 **private.key**，将它们上传到 **/etc/ssl/private** 目录，执行下面的命令。

```
chown -R nobody:nogroup /etc/ssl/private
```

- [使用证书时权限不足](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates-zh-Hans-CN)

**使用[acme](https://github.com/acmesh-official/acme.sh)申请SSL证书**

- 你需要先购买一个域名，将主域名（或添加一个子域名），指向你VPS的IP。等待约2-5分钟，让DNS解析生效。可以通过ping你设置的域名，查看返回的IP是否正确。
- [点击查看详细步骤](https://github.com/chika0801/Xray-install/blob/main/acme.md)
- 如果使用acme申请失败，请尝试使用[cerbot](https://github.com/chika0801/Xray-install/blob/main/certbot.md)。
- 备份已申请的SSL证书：进入 **/etc/ssl/private** 目录，下载证书文件 **fullchain.cer** 和私钥文件 **private.key**。
- SSL证书有效期是90天，acme每60天自动更新一次。

1. 安装[Xray](https://github.com/XTLS/Xray-core/releases)

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
```

2. 安装[Nginx](http://nginx.org/en/linux_packages.html)

- Debian 10/11

```
apt install -y gnupg2 ca-certificates lsb-release debian-archive-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && echo -e "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf && systemctl daemon-reload
```

- Ubuntu 18.04/20.04/22.04

```
apt install -y gnupg2 ca-certificates lsb-release ubuntu-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && echo -e "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf && systemctl daemon-reload
```

3. 下载[配置](https://github.com/chika0801/Xray-examples)

```
curl -Lo /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-XTLS-Vision/config_server.json && curl -Lo /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-XTLS-Vision/nginx.conf
```

4. 下载[路由规则文件加强版](https://github.com/Loyalsoldier/v2ray-rules-dat)

```
curl -Lo /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && curl -Lo /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
```

5. 启动程序

```
systemctl restart xray && systemctl restart nginx && sleep 0.2 && systemctl status xray && systemctl status nginx
```

| 项目 | |
| :--- | :--- |
| 程序 | **/usr/local/bin/xray** |
| 配置 | **/usr/local/etc/xray/config.json** |
| 检查 | `xray -test -config /usr/local/etc/xray/config.json` |
| 查看日志 | `journalctl -u xray --output cat -e` |
| 实时日志 | `journalctl -u xray --output cat -f` |

[**客户端配置示例**](https://github.com/chika0801/Xray-examples/tree/main/VLESS-XTLS-Vision)
