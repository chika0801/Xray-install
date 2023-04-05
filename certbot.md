**将 chika.example.com 替换成你设置的域名**

**使用 standalone 模式申请/更新证书时会监听 80 端口，如果 80 端口被占用会导致失败**

- 安装certbot

```
apt install -y snapd
```

```
snap install core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
```

- 使用 standalone 模式为 chika.example.com 申请 RSA 证书

```
certbot certonly --standalone --register-unsafely-without-email -d chika.example.com
```

- 将 chika.example.com 的证书安装到 /etc/ssl/private 目录

```
cp /etc/letsencrypt/archive/*/fullchain*.pem /etc/ssl/private/fullchain.cer
cp /etc/letsencrypt/archive/*/privkey*.pem /etc/ssl/private/private.key
```

- 设置证书权限，配合Xray服务端配置文件

```
chown -R nobody:nogroup /etc/ssl/private
chmod -R 0644 /etc/ssl/private/*
```

- 每个月的1日0点0分自动检查/更新证书

```
printf "0 0 1 * * /root/update_certbot.sh\n" > update && crontab update && rm update
```

```
cat > /root/update_certbot.sh << EOF
#!/usr/bin/env bash
certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
cp /etc/letsencrypt/archive/*/fullchain*.pem /etc/ssl/private/fullchain.cer
cp /etc/letsencrypt/archive/*/privkey*.pem /etc/ssl/private/private.key
EOF
```

```
chmod +x update_certbot.sh
```

- 测试更新证书

```
certbot renew --dry-run --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
```
