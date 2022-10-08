## Xray手动安装教程

准备软件

- [Xshell 7 免费版](https://www.xshell.com/zh/free-for-home-school)
- [WinSCP](https://winscp.net/eng/docs/lang:chs)

重装系统

- Debian 10
- Debian 11
- Ubuntu 18.04
- Ubuntu 20.04

开始安装

- 使用Xshell 7登录你的VPS
- 使用root用户登陆

0.已有SSL证书

- 如果你之前用acme申请了SSL证书，将证书文件改名为`fullchain.cer`，将私钥文件改名为`private.key`，使用WinSCP登录你的VPS，将它们上传到`/etc/ssl/private/`目录，执行下面的命令，跳过步骤1。

```
chown -R nobody:nogroup /etc/ssl/private/
```

[参考来源](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates-zh-Hans-CN)

#### 1.用[acme](https://github.com/acmesh-official/acme.sh)申请SSL证书

- 你先要购买一个域名，然后添加一个子域名，将子域名指向你VPS的IP。等待5-10分钟，让DNS解析生效。你可以通过ping你的子域名，查看返回的IP是否正确。确认DNS解析生效后，再执行下面的命令（每行命令依次执行）。
- 注意：将chika.example.com替换成你的子域名。

<details><summary>点击查看详细步骤</summary> 

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
chown -R nobody:nogroup /etc/ssl/private/
```

</details>

- 备份已申请的SSL证书：使用WinSCP登录你的VPS，进入`/etc/ssl/private/`目录，下载证书文件`fullchain.cer`和私钥文件`private.key`。
- SSL证书有效期是90天，每隔60几天会自动更新。[速率限制](https://letsencrypt.org/zh-cn/docs/rate-limits/)，超过次数会报错。

2.安装[Nginx](http://nginx.org/en/linux_packages.html)

- Debian 10/11

```
apt install -y gnupg2 ca-certificates lsb-release debian-archive-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf

```

- Ubuntu 18.04/20.04

```
apt install -y gnupg2 ca-certificates lsb-release ubuntu-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf
```

3.安装[Xray](https://github.com/XTLS/Xray-core/releases)

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
```

4.下载Nginx和Xray的[配置文件](https://github.com/chika0801/Xray-examples)

- [VLESS-TCP-TLS](https://github.com/chika0801/Xray-examples/tree/main/VLESS-TCP-TLS)

```
curl -Lo /etc/nginx/nginx.conf https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-TLS/nginx.conf && curl -Lo /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-TCP-TLS/config_server.json
```

5.重启Nginx和Xray

```
systemctl stop nginx && systemctl stop xray && systemctl start nginx && systemctl start xray
```

```
systemctl status nginx && systemctl status xray
```

6.日志

- 查看日志 `journalctl -u xray --output cat -e`
- 实时日志 `journalctl -u xray --output cat -f`

7.其它

- Nginx配置文件路径`/etc/nginx/nginx.conf`，Xray配置文件路径`/usr/local/etc/xray/config.json`，路由规则文件目录`/usr/local/share/xray/`。
- 修改服务器配置文件的方法：使用WinSCP登录你的VPS，进入/usr/local/etc/xray/目录，双击config.json文件，找到`"id": "",`，在`""`中间修改，Ctrl+S保存，重启Nginx和Xray。
- 若更换了配置文件，需要重启Nginx和Xray。

## v2rayN配置指南

1.[下载v2rayN](https://github.com/2dust/v2rayN/releases)，找到最新版本，在“▸ Assets”栏里，找到名为v2rayN-Core.zip的链接并下载。把压缩包解压，双击v2rayN.exe启动。

- 点击 **设置 — 参数设置** Core:DNS设置，填入1.1.1.1，将“Outbound Freedom domainStrategy”改为“AsIs”。v2rayN设置，勾选“开机自动启动”，“更新Core时忽略Geo文件”，“检查Pre-Release更新”。Core类型设置，检查各类型为“Xray”，确定。
- 点击 **设置 — 路由设置** 检查“域名解析策略”为“IPIfNonMatch”，取消勾选“启用路由高级功能”，检查“域名匹配算法”为空，点击“基础功能”，点击“一键导入基础规则”，确定，确定。

2.点击 **服务器 — 添加[VLESS]服务器** 按下图所示填写，地址填写你的子域名(例如chika.example.com)。

[VLESS-TCP-TLS](https://github.com/chika0801/Xray-examples/tree/main/VLESS-TCP-TLS#readme)

- 点击 **检查更新 — Update Geo files** 在信息栏确认有提示“下载 GeoFile: geoip 成功”，“下载 GeoFile: geoip 成功”。
- 点击服务器列表中刚才新增的服务器，**按回车键**设为活动服务器。
- 右键点击屏幕右下角的v2rayN图标，点击 **系统代理 — 自动配置系统代理**。


## v2rayN推荐设置

<details><summary>点击查看详细步骤</summary> 

![1](https://user-images.githubusercontent.com/88967758/194460235-218b0c6a-791d-47a1-98c7-366796a7a313.jpg)

![2](https://user-images.githubusercontent.com/88967758/194460232-5e5a8306-8804-4ecc-a14b-6c4fec5c06c4.jpg)

![3](https://user-images.githubusercontent.com/88967758/194460228-86d40898-bbc4-4e82-86d3-d2f1ec370308.jpg)

![4](https://user-images.githubusercontent.com/88967758/194460227-9e0f1c11-1506-4a5a-823d-be93b47547df.jpg)

![5](https://user-images.githubusercontent.com/88967758/194460226-810e2ced-23e6-4617-b50c-37cc487b4f40.jpg)

</details>
