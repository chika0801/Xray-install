# Xray手动安装教程

准备软件

Xshell 7 免费版 https://www.netsarang.com/en/free-for-home-school/ WinSCP https://winscp.net/eng/download.php

0.把VPS的系统重装为Debian 10或Debian 11，使用Xshell 7 免费版登陆你的VPS

1.安装curl wget

<pre>apt update -y && apt install -y curl wget && timedatectl set-timezone Asia/Shanghai && mkdir -p /var/log/journal</pre>

2.安装Nginx

Debian 10

<pre>wget -qO /usr/share/keyrings/nginx-archive-keyring.key https://nginx.org/keys/nginx_signing.key && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.key] https://nginx.org/packages/mainline/debian/ buster nginx" > /etc/apt/sources.list.d/sources.list && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf && nginx -v</pre>

Debian 11

<pre>wget -qO /usr/share/keyrings/nginx-archive-keyring.key https://nginx.org/keys/nginx_signing.key && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.key] https://nginx.org/packages/mainline/debian/ bullseye nginx" > /etc/apt/sources.list.d/sources.list && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf && nginx -v</pre>

3.安装Xray

<pre>bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install</pre>

4.申请免费的SSL证书

你先要购买一个域名，然后添加一个子域名，将它指向你VPS的IP。因为DNS解析需要一点时间，建议设置好了等5分钟，再执行下面的命令。你可以通过ping你的域名，查看IP是否为你VPS的IP，判断域名解析是否成功。注意：将chika.example.com替换成你的子域名。

<pre>apt install -y socat

curl https://get.acme.sh | sh

alias acme.sh=~/.acme.sh/acme.sh

acme.sh --upgrade --auto-upgrade

acme.sh --set-default-ca --server letsencrypt

acme.sh --issue -d chika.example.com --standalone --keylength ec-256

acme.sh --install-cert -d chika.example.com --ecc \

--fullchain-file /etc/ssl/private/fullchain.pem \

--key-file /etc/ssl/private/key.pem

chown -R nobody:nogroup /etc/ssl/private/</pre>

5.下载Nginx和Xray的配置文件

VLESS-TCP-XTLS（推荐使用）

<pre>wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-XTLS/nginx2.conf && wget -qO /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-XTLS/config_server.json</pre>

VLESS-gRPC

<pre>wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-gRPC/nginx2.conf && wget -qO /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-gRPC/config_server.json</pre>

6.重启Nginx和Xray

<pre>systemctl stop nginx && systemctl stop xray && systemctl start nginx && systemctl start xray  && systemctl status nginx && systemctl status xray</pre>

7.下载和设置v2rayN

下载链接 https://github.com/2dust/v2rayN/releases/download/4.20/v2rayN-Core.zip
解压后运行v2rayN.exe。

点击“设置 — 参数设置 — v2rayN设置”，将Core类型改为“Xray_core”，确定。

点击“设置 — 路由设置 — 基础功能 — 一键导入基础规则 — 确定”。

右键点击屏幕右下角的v2rayN图标，点击“系统代理 — 自动配置系统代理”。

8.在v2rayN中添加服务器

<details><summary>VLESS-TCP-XTLS</summary>

点击“服务器 — 添加[VLESS]服务器”，按下图所示填写，地址填写你的子域名(例如chika.example.com)

![VLESS-TCP-XTLS](https://user-images.githubusercontent.com/88967758/132801053-cc8b3aee-5da8-45d5-9e23-115f3b766e52.jpg)</details>

<details><summary>VLESS-gRPC</summary>

点击“服务器 — 添加[VLESS]服务器”，按下图所示填写，地址填写你的子域名(例如chika.example.com)

![VLESS-gRPC](https://user-images.githubusercontent.com/88967758/132800221-1e67083c-6d38-4f00-8f24-38ae688f3d09.jpg)</details>

点击“检查更新 — Xray-Core — 是否下载? — 是”。

现在你已经能科学上网了。

9.修改服务器配置文件的方法

使用WinSCP登陆你的VPS，进入/usr/local/etc/xray/目录，双击config.json文件编辑，找到"id": "chika"，修改后并保存，然后重启Nginx和Xray，使其生效。

10.SSL证书是每90天自动更新，更新时需要使用80端口，因此在Nginx的配置文件中，没有监听80端口。申请免费证书，每周限制5次，超过次数会报错，具体限制规则https://letsencrypt.org/zh-cn/docs/rate-limits/

<details><summary>手动更新SSL证书命令</summary>

<pre>acme.sh --renew -d chika.example.com --force --ecc</pre></details>
