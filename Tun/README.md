### 快速安装

<details><summary>点击查看</summary><br>

1. 参考 [sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/blob/main/Tun/README.md)，将 [sing-box Windows 客户端配置](https://github.com/chika0801/sing-box-examples/blob/main/Tun/config_client_windows.json) 进行如下修改。

原内容
```jsonc
        {
            "type": "vless",
            "tag": "proxy",
            "server": "", // 服务端的 IP
            "server_port": 443,
            "uuid": "chika",
            "flow": "xtls-rprx-vision",
            "tls": {
                "enabled": true,
                "server_name": "www.lovelive-anime.jp",
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                },
                "reality": {
                    "enabled": true,
                    "public_key": "Z84J2IelR9ch3k8VtlVhhs5ycBUlXA7wHBWcBrjqnAw",
                    "short_id": "6ba85179e30d4fc2"
                }
            },
            "packet_encoding": "xudp"
        },
```

替换为
```jsonc
        {
            "type": "socks",
            "tag": "proxy",
            "server": "127.0.0.1",
            "server_port": 10808,
            "version": "5"
        },
```

2. 在v2rayN中添加自定义配置服务器，使用这个 [v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)，Core类型选Xray，Socks端口填0。
3. 在服务端安装 Xray，使用这个 [Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。

</details>

### 工作流程

1. 由 **sing-box** 提供 **Tun** 模式（透明代理环境），接管程序发出的网络访问请求（域名或IP）。域名进入 **"dns"** 部分，按预设的规则进行DNS解析，解析返回的IP（直接请求的IP）进入 **"route"** 部分。使用 **"sniff"** 参数，获得DNS解析前的域名（直接请求的IP无域名）。IP和域名作为条件，按预设的规则进行分流。sing-box发送到Xray的是 **IP**，并且不使用 **"sniff_override_destination"** 参数，不会把IP还原成域名。
2. Xray接收到sing-box发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。Xray只负责连接服务端。
3. 服务端接收到客户端发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。

### 注意事项

1. 默认 **Xray** 和 **sing-box** 使用最新版本。
2. 协议组合用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。
3. 若 **sing-box.exe** 莫名出现CPU、内存占用猛增，日志快速刷新报错信息，**建议直接放弃这套方案，不要浪费时间研究原因**。
4. 分流相关的问题，若服务端有例如将netflix的域名分流到另外一个VPS的需求（或使用warp解锁openai），可尝试使用 **"sniffing"** + **"routeOnly": true** 的参数内容。此时服务端会将请求的IP还原成域名，进入路由部分，匹配到对应的域名转发规则，但是发送（出站）的请求还是IP。所以如果出现netflix解锁失败，需要在解锁VPS的配置中添加 **"sniffing"** + **"routeOnly": false** 的参数内容。
