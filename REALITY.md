1. 安装Xray

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
```

2. 下载配置（VLESS-XTLS-uTLS-REALITY）

```
curl -Lo /usr/local/etc/xray/config.json https://raw.githubusercontent.com/chika0801/Xray-examples/main/VLESS-XTLS-uTLS-REALITY/config_server.json
```

3. 重启Xray

```
systemctl restart xray && sleep 0.2 && systemctl status xray
```
