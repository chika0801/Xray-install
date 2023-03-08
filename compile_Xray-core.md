**以 Debian 11 为例，使用 root 用户登录**

```
curl -sLo go.tar.gz https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
echo -e 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
source /etc/profile.d/go.sh
```

```
apt install -y git
```

```
git clone https://github.com/XTLS/Xray-core.git
cd Xray-core
go mod download -x
```

**linux-amd64**

```
go build -v -o xray -trimpath -ldflags "-s -w -buildid=" ./main
```

**windows-amd64**

```
GOOS=windows GOARCH=amd64 go build -v -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main
```
