**注意：**

:exclamation:配置示例用 **VLESS-XTLS-uTLS-REALITY** 举例，如需改用其它协议组合，请自行参照修改。

1. 参考 [Xray REALITY 安装指南](https://github.com/chika0801/Xray-install/blob/main/REALITY.md)，使用这个[Xray 服务端配置文件](https://github.com/chika0801/Xray-install/blob/main/Tun/Xray_server_config.json)，主要区别是服务端接收到的客户端请求是 **IP**（若客户端sing-box使用fakeip，则收到的是域名），并且不使用 **"sniffing"** 参数，未阻止 cn ip 出站。

2. 参考 [sing-box Windows 客户端使用方法](https://github.com/chika0801/sing-box-examples/tree/main/Tun)，使用这个[sing-box 客户端配置文件](https://github.com/chika0801/Xray-examples/blob/main/Tun/sing-box_client_config.json)，主要区别是由 **sing-box** 处理 DNS 请求，处理路由，并且不使用 **"sniff_override_destination"** 参数

3. 在v2rayN中添加自定义服务器，使用这个[v2rayN 客户端配置文件](https://github.com/chika0801/Xray-examples/blob/main/Tun/v2rayN_client_config.json)，主要区别是 **Xray** 只负责连接服务端，使用到 Xray 1.8.1 版本的新特性
