准备环境

```
curl -sLo go.tar.gz https://go.dev/dl/$(curl -sL https://golang.org/VERSION?m=text|head -1).linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local/ -xzf go.tar.gz
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
```

更新代码

```
cd Xray-core
git pull
cd ..
```

编译命令

**linux-amd64**

```
cd Xray-core
sed -i '/build/ s/Custom/'$(git rev-parse --short HEAD)'/' ./core/core.go
go mod download
go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOAMD64=v2
go build -v -o xray -trimpath -ldflags "-s -w -buildid=" ./main
cd ..
```

**windows-amd64**

```
cd Xray-core
sed -i '/build/ s/Custom/'$(git rev-parse --short HEAD)'/' ./core/core.go
go mod download
go env -w CGO_ENABLED=0 GOOS=windows GOARCH=amd64 GOAMD64=v3
go build -v -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main
cd ..
```

[About GOAMD64](https://github.com/golang/go/wiki/MinimumRequirements#amd64)

复制文件

**linux-amd64**

```
cp -f Xray-core/xray /usr/local/bin/
chmod +x /usr/local/bin/xray
```

**windows-amd64**

```
cp -f Xray-core/xray.exe .
```
