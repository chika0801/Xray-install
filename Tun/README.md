快速安装

1. 参考[Xray REALITY 安装指南](https://github.com/chika0801/Xray-install/blob/main/REALITY.md)，使用这个[Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)。主要区别是服务端接收到的客户端请求是 **IP**，并且不使用 **"sniffing"** 参数，即不把请求的IP还原成域名，就不会再进行一次DNS解析。

2. 参考[sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/tree/main/Tun)，使用这个[sing-box 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config.json)。主要区别是由 **sing-box** 提供 **Tun** 模式，处理透明代理环境下的DNS解析，把解析后得到的IP，通过嗅探获得域名，IP和域名作为匹配条件，进入路由部分，并且不使用 **"sniff_override_destination"** 参数，即发送到服务端的请求是IP，不把IP还原成域名发送到服务端。

3. 在v2rayN中添加自定义服务器，使用这个[v2rayN 客户端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/v2rayN_client_config.json)。主要区别是 **Xray** 只负责连接服务端，并且使用到 Xray 最新版本的新特性。

注意事项

1. 协议组合用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。

2. 若 sing-box 出现突然CPU、内存占用猛增，甚至蓝屏，日志快速刷新报错信息。建议尝试使用 [**fakeip**](https://github.com/chika0801/Xray-install/blob/main/Tun/sing-box_client_config_fakeip.json) 模式，如果还是复现，建议尝试使用其它协议组合。如果还是不能解决，建议放弃这套方案，直接用 [**sing-box**](https://github.com/chika0801/sing-box-examples/tree/main/Tun) 出站连接服务端。
