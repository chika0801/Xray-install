**你需要先购买一个域名，将主域名（或添加一个子域名），指向你VPS的IP。等待约2-5分钟，让DNS解析生效。可以通过ping你设置的域名，查看返回的IP是否正确**

**将 chika.example.com 替换成你设置的域名**

**使用 standalone 模式申请/更新证书时会监听 80 端口，如果 80 端口被占用会导致失败**

- 安装acme

```
apt install -y socat
```

```
curl https://get.acme.sh | sh
```

- 设置acme的别名

```
alias acme.sh=~/.acme.sh/acme.sh
```

- 设置acme自动更新

```
acme.sh --upgrade --auto-upgrade
```

- 将默认 CA 更改为 Let's Encrypt

```
acme.sh --set-default-ca --server letsencrypt
```

- 使用 standalone 模式为 chika.example.com 申请 ECC 证书

```
acme.sh --issue -d chika.example.com --standalone --keylength ec-256
```

- 将 chika.example.com 的证书安装到 /etc/ssl/private 目录

```
acme.sh --install-cert -d chika.example.com --ecc \
--fullchain-file /etc/ssl/private/fullchain.cer \
--key-file /etc/ssl/private/private.key
```

- 设置证书权限，配合Xray服务端配置文件

```
chown -R nobody:nogroup /etc/ssl/private
```

- 强制更新证书

```
acme.sh --renew -d chika.example.com --force --ecc
```
