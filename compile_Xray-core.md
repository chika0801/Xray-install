**以 Debian 11 为例，使用 root 用户登录**

```
curl -sLo go.tar.gz https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
apt install -y git
```

```
git clone https://github.com/XTLS/Xray-core.git
cd Xray-core
go mod download
```

**linux-amd64**

```
CGO_ENABLED=0 go build -o xray -trimpath -ldflags "-s -w -buildid=" ./main
```

```
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
```

```
systemctl stop xray
cp xray /usr/local/bin
systemctl start xray
cd ..
rm -rf go Xray-core
```

**windows-amd64**

```
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main
```
