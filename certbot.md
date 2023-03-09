- 安装certbot

```
apt install -y snapd
```

```
snap install core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
```

- certbot使用standalone模式申请/更新证书时会监听80端口，如果80端口被占用会导致失败

```
certbot certonly --standalone --register-unsafely-without-email -d chika.example.com
```

- 将证书文件和私钥文件，复制到 /etc/ssl/private 目录，配合Xray服务端配置文件

```
cp /etc/letsencrypt/archive/*/fullchain*.pem /etc/ssl/private/fullchain.cer
cp /etc/letsencrypt/archive/*/privkey*.pem /etc/ssl/private/private.key
chown -R nobody:nogroup /etc/ssl/private
chmod -R 0644 /etc/ssl/private/*
```

- 每个月的1日0点自动检查/更新证书

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
