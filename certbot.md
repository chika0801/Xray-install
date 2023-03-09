```
apt install -y snapd
```

```
snap install core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
```

```
certbot certonly --standalone --register-unsafely-without-email -d chika.example.com
```

```
cp /etc/letsencrypt/archive/*/fullchain*.pem /etc/ssl/private/fullchain.cer
cp /etc/letsencrypt/archive/*/privkey*.pem /etc/ssl/private/private.key
chown -R nobody:nogroup /etc/ssl/private
chmod -R 0644 /etc/ssl/private/*
```

```
printf "0 7 * * * /root/update_certbot.sh\n" > update && crontab update && rm update
```

```
cat > /root/update_certbot.sh << EOF
#!/usr/bin/env bash
certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
cp /etc/letsencrypt/archive/*/privkey*.pem /etc/ssl/private/private.key
cp /etc/letsencrypt/archive/*/fullchain*.pem /etc/ssl/private/fullchain.cer
EOF
```

```
chmod +x update_certbot.sh
```
