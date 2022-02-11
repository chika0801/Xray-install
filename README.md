## Xray + VLESS-TCP-XTLS/VLESS-gRPC-TLS 手动安装教程

准备软件

- [Xshell 7 免费版](https://www.xshell.com/zh/free-for-home-school/)
- [WinSCP](https://winscp.net/eng/docs/lang:chs)

重装系统（新手不建议开始就[网络重装系统](https://github.com/bohanyang/debi)，去你的VPS网站上操作，重装系统为Deian10或11）

- Debian 10
- Debian 11
- Ubuntu 18.04
- Ubuntu 20.04

开始安装

- 使用Xshell 7连接你的VPS
- 使用root用户登陆
- 如果你已有SSL证书，将证书文件改名为fullchaincert.cer，将密钥文件改名为certkey.key，使用WinSCP连接你的VPS，将它们上传到/etc/ssl/private/目录，执行`chown -R nobody:nogroup /etc/ssl/private/`命令，跳过步骤1

0.安装curl（可选）

```
apt update -y && apt install -y curl
```

1.申请[免费的SSL证书](https://github.com/acmesh-official/acme.sh)

- 你先要购买一个域名，然后添加一个子域名，将子域名指向你VPS的IP。因为DNS解析需要一点时间，建议设置好了等5分钟，再执行下面的命令（每行命令依次执行）。你可以通过ping你的子域名，查看返回的IP是否正确。注意：将chika.example.com替换成你的子域名。

<pre>apt install -y socat

curl https://get.acme.sh | sh

alias acme.sh=~/.acme.sh/acme.sh

acme.sh --upgrade --auto-upgrade

acme.sh --set-default-ca --server letsencrypt

acme.sh --issue -d chika.example.com --standalone --keylength ec-384

acme.sh --install-cert -d chika.example.com --ecc \

--fullchain-file /etc/ssl/private/fullchaincert.cer \

--key-file /etc/ssl/private/certkey.key

chown -R nobody:nogroup /etc/ssl/private/</pre>

- 备份已申请的SSL证书：使用WinSCP连接你的VPS，进入/etc/ssl/private/目录，下载fullchaincert.cer和certkey.key文件

2.安装[Nginx](http://nginx.org/en/linux_packages.html)

- Debian 10/11
```
apt install -y gnupg2 ca-certificates lsb-release debian-archive-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/debian `lsb_release -cs` nginx\n" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
```

- Ubuntu 18.04/20.04
```
apt install -y gnupg2 ca-certificates lsb-release ubuntu-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx\n" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
```

3.安装[Xray](https://github.com/XTLS/Xray-core/releases)

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
```

4.1下载Nginx和Xray的配置文件（二选一）

- [VLESS-TCP-XTLS](https://github.com/chika0801/Xray-examples/tree/main/VLESS-TCP-XTLS)（推荐使用）

```
curl -Lo /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-XTLS/nginx.conf && curl -Lo /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-XTLS/config_server.json
```

- [VLESS-gRPC-TLS](https://github.com/chika0801/Xray-examples/tree/main/VLESS-gRPC-TLS)

```
curl -Lo /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-gRPC-TLS/nginx.conf && curl -Lo /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-gRPC-TLS/config_server.json
```

- 若更换了配置文件，需要重启Nginx和Xray，使其生效。

4.2下载[路由规则文件加强版](https://github.com/Loyalsoldier/v2ray-rules-dat)

```
curl -Lo /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && curl -Lo /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
```

5.重启Nginx和Xray

```
systemctl stop nginx && systemctl stop xray && systemctl start nginx && systemctl start xray
```

6.查看Nginx和Xray状态

```
systemctl status nginx && systemctl status xray
```

7.自动更新路由规则文件加强版（可选）

```
printf "0 7 * * * /root/update_geodata.sh\n" > /root/update_geodata && crontab /root/update_geodata && printf "curl -sSLo /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat\ncurl -sSLo /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat\nsleep 2\nsystemctl restart xray\n" > /root/update_geodata.sh && chmod +x /root/update_geodata.sh
```

8.其它

- Xray配置文件路径`/usr/local/etc/xray/config.json` Nginx配置文件路径`/etc/nginx/nginx.conf` 路由规则文件目录`/usr/local/share/xray`

- 修改服务器配置文件的方法：使用WinSCP连接你的VPS，进入/usr/local/etc/xray/目录，双击config.json文件编辑，找到"id": "chika"，修改后并保存，然后重启Nginx和Xray，使其生效。

- SSL证书是每90天自动更新，更新时需要使用80端口，因此在Nginx的配置文件中，没有监听80端口。申请免费证书，每周限制5次，超过次数会报错，[具体限制规则](https://letsencrypt.org/zh-cn/docs/rate-limits/)

## v2rayN配置指南

1.[打开链接1](https://github.com/2dust/v2rayN/releases)， 点击最新版本栏里的“▸ Assets”，找到名为v2rayN.zip的链接并下载。
[打开链接2](https://github.com/XTLS/Xray-core/releases) ，点击最新版本栏里的“▸ Assets”，找到名为Xray-windows-64.zip的链接并下载。
把2个压缩包解压，复制xray.exe到v2rayN文件夹里面，运行v2rayN.exe。

- 点击 设置 — 参数设置 — Core:DNS设置，1.1.1.1。v2rayN设置，勾选“更新Core时忽略Geo文件”，将“Core类型”改为“Xray_core”，确定。
- 点击 设置 — 路由设置，将“域名解析策略”改为“IPIfNonMatch”，取消勾选“启用路由高级功能”，将“域名匹配算法”改为“mph”，点击“基础功能”，点击“一键导入基础规则”，确定，确定。
- 右键点击屏幕右下角的v2rayN图标，点击“系统代理 — 自动配置系统代理”。

2.点击“服务器 — 添加[VLESS]服务器”，按下图所示填写，地址填写你的子域名(例如chika.example.com)

[VLESS-TCP-XTLS](https://github.com/chika0801/Xray-examples/blob/main/VLESS-TCP-XTLS/README.md#%E5%AE%A2%E6%88%B7%E7%AB%AFv2rayn%E9%85%8D%E7%BD%AE%E6%96%B9%E5%BC%8F)

[VLESS-gRPC-TLS](https://github.com/chika0801/Xray-examples/tree/main/VLESS-gRPC-TLS#%E5%AE%A2%E6%88%B7%E7%AB%AFv2rayn%E9%85%8D%E7%BD%AE%E6%96%B9%E5%BC%8F)

- 点击服务器列表中刚才新增的服务器，按回车键载入配置。

3.点击“检查更新
- 点击“Update GeoSite — 是否下载? — 是”。
- 点击“Update GeoIP — 是否下载? — 是”。

## v2rayNG配置指南

1.在电脑上下载[v2rayNG](https://github.com/2dust/v2rayNg/releases)，如v2rayNG_1.x.x_arm64-v8a.apk。

2.在电脑上下载路由规则文件加强版，[geoip.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat)和[geosite.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat)。

3.把v2rayNG_1.x.x_arm64-v8a.apk，geoip.dat，geosite.dat，用数据线复制到手机，在手机上安装v2rayNG。

4.进入v2rayNG，点击左上角`≡` —— 设置，勾选“启用本地DNS”，“域名策略”改为“IPIfNonMatch”，“预定义规则”改为“绕过局域网及大陆地址而后代理”。

5.点击左上角`≡` —— Geo 资源文件，点击右上角`+`，分别选择geoip.dat和geosite.dat。

6.在电脑上打开v2rayN，选择要使用的服务器，点击“分享”。

7.点击右上角`+` —— 扫描二维码，扫描刚才的二维码。

8.点击右下角的灰色`V`字母图标。

## 注意事项

1.[为什么要禁止VPS访问CN域名和IP](https://github.com/XTLS/Xray-core/discussions/593#discussioncomment-845165)。

2.若使用其它客户端，需设置好CN域名和IP直连，否则将在VPS端被阻止。
