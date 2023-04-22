**快速安装**

1. 参考[sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/tree/main/Tun)，使用这个[sing-box 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json)。

- 由 **sing-box** 提供 **Tun** 模式（透明代理环境），接管程序发出的网络访问请求（域名或IP）。域名进入 **"dns"** 部分，按[预设的规则](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json#L26)进行DNS解析，解析返回的IP（直接请求的IP）进入 **"route"** 部分。使用 **"sniff"** 参数，获得DNS解析前的域名（直接请求的IP无域名）。IP和域名作为条件，按[预设的规则](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json#L62)进行分流。sing-box发送到Xray的是 **IP**，并且不使用 **"sniff_override_destination"** 参数，不会把IP还原成域名。

2. 在v2rayN中添加自定义服务器，使用这个[v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)。

- Xray接收到sing-box发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。Xray只负责连接服务端。

3. 参考[Xray REALITY 安装指南](https://github.com/chika0801/Xray-install/blob/main/REALITY.md)，使用这个[Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。

- 服务端接收到客户端发送来的 **IP**，并且不使用 **"sniffing"** 参数，不会把IP还原成域名。

**注意事项**

1. 默认 **Xray** 和 **sing-box** 使用最新版本。

2. 协议组合用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。

3. 若 **sing-box.exe** 莫名出现CPU、内存占用猛增，日志快速刷新报错信息，建议尝试以下方法。

- 重启Windows系统。
- 将sing-box客户端配置文件中的`"stack": "system",`改为`"stack": "gvisor",`。
- 尝试使用其它协议组合。
- 放弃这套方案，使用 [**sing-box**](https://github.com/chika0801/sing-box-examples/tree/main/Tun) 出站连接服务端。

4. 先有鸡还是先有蛋的问题，建议提前在sing-box所在文件夹里准备好[geoip.db](https://github.com/soffchen/sing-geoip/releases)和[geosite.db](https://github.com/soffchen/sing-geoip/releases)文件。谁先启动的问题，我是v2rayN开机自启，手动运行sing-box。

5. 分流相关的问题，若服务端有例如将netflix的域名分流到另外一个VPS的需求（或使用warp解锁openai），可尝试使用 **"sniffing"** + **"routeOnly": true** 的参数内容。此时服务端会将请求的IP还原成域名，进入路由部分，匹配到对应的域名转发规则，但是发送（出站）的请求还是IP。所以如果出现netflix解锁失败，需要在解锁VPS的配置中添加 **"sniffing"** + **"routeOnly": false** 的参数内容。

```
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls",
                    "quic"
                ],
            "routeOnly": true
            }
```

**参考链接**

1. https://sing-box.sagernet.org/zh/faq/fakeip/

2. https://sekai.icu/posts/udp-fqdn-in-transport-proxy/
