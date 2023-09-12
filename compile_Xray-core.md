准备环境

```
curl -L https://go.dev/dl/$(curl -sL https://golang.org/VERSION?m=text|head -1).linux-amd64.tar.gz >> go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
echo -e "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh
source /etc/profile.d/go.sh
go version
```

```
apt install -y git
```

下载代码

```
git clone https://github.com/XTLS/Xray-core.git
cd Xray-core
go mod download
```

更新代码

```
cd Xray-core
git pull
go mod download
```

编译命令

**linux-amd64**

```
export CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOAMD64=v2
go build -v -o xray -trimpath -ldflags "-s -w -buildid=" ./main
```

**windows-amd64**

```
export CGO_ENABLED=0 GOOS=windows GOARCH=amd64 GOAMD64=v3
go build -v -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main
```

[About GOAMD64](https://github.com/golang/go/wiki/MinimumRequirements#amd64)

复制文件

**linux-amd64**

```
cp -f /root/Xray-core/xray /usr/local/bin/xray && chmod +x /usr/local/bin/xray
```

**windows-amd64**

```
cp -f /root/Xray-core/xray.exe /root/xray.exe
```
