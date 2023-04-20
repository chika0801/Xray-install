快速安装

1. 参考[Xray REALITY 安装指南](https://github.com/chika0801/Xray-install/blob/main/REALITY.md)，使用这个[Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。主要区别是服务端接收到的客户端请求是 **IP**，并且不使用 **"sniffing"** 参数，即不把请求的IP还原成域名，就不会再进行一次DNS解析。

2. 参考[sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/tree/main/Tun)，使用这个[sing-box 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json)。主要区别是由 **sing-box** 提供 **Tun** 模式，处理透明代理环境下的DNS解析，把解析后得到的IP，通过嗅探获得域名，IP和域名作为匹配条件，进入路由部分，并且不使用 **"sniff_override_destination"** 参数，即发送到服务端的请求是IP，不把IP还原成域名发送到服务端。

3. 在v2rayN中添加自定义服务器，使用这个[v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)。主要区别是 **Xray** 只负责连接服务端，并且使用到最新版本的功能。

注意事项

0. 默认 Xray 和 sing-box 均使用最新版本。

1. 协议组合用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。

2. 若 **sing-box.exe** 莫名出现CPU、内存占用猛增，日志快速刷新报错信息，建议尝试以下方法。

- 重启Windows系统。
- 将sing-box客户端配置文件中的`"stack": "system",`改为`"stack": "gvisor",`。
- 使用sing-box客户端配置文件 [**fakeip**](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config_fakeip.json) 版本。
- 尝试使用其它协议组合。
- 建议放弃这套方案，使用 [**sing-box**](https://github.com/chika0801/sing-box-examples/tree/main/Tun) 出站连接服务端。
- 重装Windows系统。

3. 先有鸡还是先有蛋的问题，建议提前在sing-box所在文件夹里准备好geoip.db和geosite.db文件。谁先启动有无影响的问题，我自己是v2rayN开机自启，然后手动启动sing-box打开Tun模式。

4. 若服务端有例如将netflix的域名分流到另外一个VPS的需求（或使用warp解锁openai），可尝试使用 **"sniffing"** + **"routeOnly": true** 的参数内容。此时服务端会将请求的IP还原成域名，进入路由部分，匹配到对应的域名转发规则，但是发送（出站）的请求还是IP。所以如果出现netflix解锁失败，需要在解锁VPS的配置中添加 **"sniffing"** + **"routeOnly": false** 的参数内容。

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
