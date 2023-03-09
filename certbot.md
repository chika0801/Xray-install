```
apt install -y snapd
```

```
snap install core
```

```
snap install --classic certbot
```

```
ln -s /snap/bin/certbot /usr/bin/certbot
```

```
certbot certonly --standalone --register-unsafely-without-email -d chika.example.com
```

```
cp /etc/letsencrypt/archive/*/privkey1.pem /etc/ssl/private/private.key
cp /etc/letsencrypt/archive/*/fullchain1.pem /etc/ssl/private/fullchain.cer
```

```
chown -R nobody:nogroup /etc/ssl/private
chmod -R 0644 /etc/ssl/private/*
```

```
printf "0 7 * */2 * /root/update_certbot.sh\n" > update && crontab update && rm update
```

```
cat > /root/update_certbot.sh << EOF
#!/usr/bin/env bash
certbot renew
cp /etc/letsencrypt/archive/*/privkey1.pem /etc/ssl/private/private.key
cp /etc/letsencrypt/archive/*/fullchain1.pem /etc/ssl/private/fullchain.cer
systemctl restart xray
EOF
```

```
chmod +x update_certbot.sh
```
