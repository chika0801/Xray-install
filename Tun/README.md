快速安装

1. 参考[Xray REALITY 安装指南](https://github.com/chika0801/Xray-install/blob/main/REALITY.md)，使用这个[Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。简易说明：服务端接收到的客户端请求是 **IP**，并且不使用 **"sniffing"** 参数。即服务端不把接收到的IP还原成域名，就不会再进行一次DNS解析。

2. 参考[sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/tree/main/Tun)，使用这个[sing-box 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json)。简易说明：由 **sing-box** 提供 **Tun** 模式（透明代理环境），接管程序发出的网络访问请求（域名或IP）。域名进入 **"dns"** 部分，按预设的规则进行DNS解析，解析返回的IP（直接请求的IP）进入 **"route"** 部分。使用 **"sniff"** 参数，获得IP被解析前的域名（直接请求的IP无域名信息）。IP和域名作为条件，按预设的规则进行分流。并且不使用 **"sniff_override_destination"** 参数。即sing-box发送到Xray的请求是IP，不把IP还原成域名发送到Xray。

3. 在v2rayN中添加自定义服务器，使用这个[v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)。简易说明：Xray接收到sing-box发送来的IP，只负责连接服务端，并且使用到最新版本的功能。

4. 在v2rayNG中添加自定义配置，使用这个[v2rayNG 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayNG_client_config.json)，并在v2rayNG的设置中勾选`启用本地DNS`。

注意事项

0. 默认 Xray 和 sing-box 均使用最新版本。

1. 协议组合用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。

2. 若 **sing-box.exe** 莫名出现CPU、内存占用猛增，日志快速刷新报错信息，建议尝试以下方法。

- 重启Windows系统。
- 将sing-box客户端配置文件中的`"stack": "system",`改为`"stack": "gvisor",`。
- 使用sing-box客户端配置文件 [**fakeip**](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config_fakeip.json) 版本。
- 尝试使用其它协议组合。
- 放弃这套方案，使用 [**sing-box**](https://github.com/chika0801/sing-box-examples/tree/main/Tun) 出站连接服务端。
- 重装Windows系统。

3. 先有鸡还是先有蛋的问题，建议提前在sing-box所在文件夹里准备好geoip.db和geosite.db文件。谁先启动的问题，我自己是v2rayN开机自启，然后手动启动sing-box打开Tun模式。

4. 分流相关的问题，若服务端有例如将netflix的域名分流到另外一个VPS的需求（或使用warp解锁openai），可尝试使用 **"sniffing"** + **"routeOnly": true** 的参数内容。此时服务端会将请求的IP还原成域名，进入路由部分，匹配到对应的域名转发规则，但是发送（出站）的请求还是IP。所以如果出现netflix解锁失败，需要在解锁VPS的配置中添加 **"sniffing"** + **"routeOnly": false** 的参数内容。

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

参考链接

1. https://sing-box.sagernet.org/zh/faq/fakeip/

2. https://sekai.icu/posts/udp-fqdn-in-transport-proxy/

3. https://blog.skk.moe/post/i-have-my-unique-dns-setup/
