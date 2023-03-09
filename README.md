## [XTLS Vision](https://github.com/XTLS/Xray-core/discussions/1295) 安装指南

**已有SSL证书**

- 将证书文件改名为 **fullchain.cer**，将私钥文件改名为 **private.key**，将它们上传到 **/etc/ssl/private** 目录，执行下面的命令。

```
chown -R nobody:nogroup /etc/ssl/private
```

#### 用[acme](https://github.com/acmesh-official/acme.sh)申请SSL证书

- 你需要先购买一个域名，将主域名（或添加一个子域名），指向你VPS的IP。等待约2-5分钟，让DNS解析生效。可以通过ping你设置的域名，查看返回的IP是否正确。确认DNS解析生效后，再执行下面的命令（每行命令依次执行）。将chika.example.com替换成你设置的域名。
- acme使用standalone模式申请/更新证书时会监听80端口，如果80端口被占用会导致失败。
- Let's Encrypt [速率限制](https://letsencrypt.org/zh-cn/docs/rate-limits/)。
- 如果使用acme申请失败，请尝试使用[cerbot](https://github.com/chika0801/Xray-install/blob/main/certbot.md)。

<details><summary>点击查看详细步骤</summary><br>

```
apt install -y socat
```

```
curl https://get.acme.sh | sh
```

```
alias acme.sh=~/.acme.sh/acme.sh
```

```
acme.sh --upgrade --auto-upgrade
```

```
acme.sh --set-default-ca --server letsencrypt
```

```
acme.sh --issue -d chika.example.com --standalone --keylength ec-256
```

```
acme.sh --install-cert -d chika.example.com --ecc \
```

```
--fullchain-file /etc/ssl/private/fullchain.cer \
```

```
--key-file /etc/ssl/private/private.key
```

```
chown -R nobody:nogroup /etc/ssl/private
```

</details>

- 备份已申请的SSL证书：进入 **/etc/ssl/private** 目录，下载证书文件 **fullchain.cer** 和私钥文件 **private.key**。
- SSL证书有效期是90天，acme每60天自动更新一次。

1. 安装[Xray](https://github.com/XTLS/Xray-core/releases)

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
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

## v2rayN 6.x 配置指南

<details><summary>点击查看</summary><br>

服务器 ——> 添加[VLESS服务器]

![1](https://user-images.githubusercontent.com/88967758/213372857-49306ebe-f2fc-4426-91df-fd54e096456a.jpg)

</details>

## v2rayN 5.x 配置指南

<details><summary>点击查看</summary><br>

服务器 ——> 添加[VLESS服务器]

![1](https://user-images.githubusercontent.com/88967758/212540248-043ab1ed-af87-4e48-87b7-895018f4a52d.jpg)

</details>

## v2rayNG 配置指南

<details><summary>点击查看</summary><br>

| 选项 | 值 |
| :--- | :--- |
| 地址(address) | chika.example.com |
| 端口(prot) | 443 |
| 用户ID(id) | chika |
| 流控(flow) | xtls-rprx-vision |
| 传输协议(network) | tcp |
| 传输层安全(tls) | tls |
| SNI | 留空 |
| uTLS | chrome |

</details>

## ShadowSocksR Plus+ 配置指南

<details><summary>点击查看</summary><br>

| 选项 | 值 |
| :--- | :--- |
| 服务器节点类型 | V2Ray/Xray |
| V2Ray/XRay 协议 | VLESS |
| 服务器地址 | chika.example.com |
| 端口 | 443 |
| Vmess/VLESS ID (UUID) | chika |
| VLESS 加密 | none |
| 传输协议 | TCP |
| 伪装类型 | 无 |
| TLS | 勾上 |
| 流控（Flow） | xtls-rprx-vision |
| 指纹伪造 | chrome |
| TLS 主机名 | 留空 |
| TLS ALPN | 留空 |
| 允许不安全连接 | 不勾 |
| Mux | 不勾 |
| 自签证书 | 不勾 |
| 启用自动切换 | 不勾 |
| 本地端口 | 1234 |

</details>

## PassWall 配置指南

<details><summary>点击查看</summary><br>

| 选项 | 值 |
| :--- | :--- |
| 类型 | Xray |
| 传输协议 | VLESS |
| 地址（支持域名） | chika.example.com |
| 端口 | 443 |
| 加密方式 | none |
| ID | chika |
| TLS | 勾上 |
| flow | xtls-rprx-vision |
| alpn | 默认 |
| 域名 | 留空 |
| 允许不安全连接 | 不勾 |
| 指纹伪造 | chrome |
| 传输协议 | TCP |
| 伪装类型 | none |
| Mux | 不勾 |

</details>
