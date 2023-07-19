### 快速安装

1. 参考 [sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/blob/main/Tun/README.md)，将 [sing-box Windows 客户端配置](https://github.com/chika0801/sing-box-examples/blob/main/Tun/config_client_windows.json) 进行如下修改。

原内容
```jsonc
        {
            // 粘贴你的客户端配置，需要保留 "tag": "proxy"
            "tag": "proxy"
        },
```

替换为
```jsonc
        {
            "type": "socks",
            "tag": "proxy",
            "server": "127.0.0.1",
            "server_port": 50000
        },
```

2. 在v2rayN中添加自定义配置服务器，使用这个 [v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)，Core类型选Xray，Socks端口填0。
3. 在服务端安装 Xray，使用这个 [Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。

### 工作流程

1. 由 **sing-box** 提供 **Tun** 模式（透明代理环境），接管程序发出的网络访问请求（域名或IP）。域名进入 **"dns"** 部分，按预设的规则进行匹配并做DNS解析，解析返回的IP（直接请求的IP）进入 **"route"** 部分。使用 **"sniff"** 参数，获得DNS解析前的域名（直接请求的IP无域名）。IP和域名作为条件，按预设的规则进行分流。sing-box发送到Xray的是 **IP**，并且不使用 **"sniff_override_destination"** 参数，不会把IP还原成域名。
2. Xray接收到sing-box发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。Xray只负责连接服务端。
3. 服务端接收到客户端发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。
