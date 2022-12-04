FROM amazonlinux:2

WORKDIR /go/src/

# Install nginx.
RUN yum -y update && \
    amazon-linux-extras info nginx1 && \
    amazon-linux-extras install nginx1

RUN yum update -y
RUN yum install -y gcc bzip2 bzip2-devel openssl openssl-devel readline readline-devel git wget gcc-c++ unixODBC-devel tar.x86_64 zip unzip procps glibc-langpack-ja which

RUN mkdir /temp
RUN cd /temp

RUN wget https://golang.org/dl/go1.18.linux-amd64.tar.gz
RUN tar -C /temp -xzf go1.18.linux-amd64.tar.gz

RUN mv /temp/go /usr/lib/golang

RUN GOARCH="amd64" GOCACHE="/root/.cache/go-build" GOENV="/root/.config/go/env" GOHOSTARCH="amd64" GOHOSTOS="linux" GOMODCACHE="/root/go/pkg/mod" GOOS="linux" \
 GOPATH="/root/go" GOPROXY="https://proxy.golang.org,direct" \
 GOROOT="/usr/lib/golang" GOSUMDB="sum.golang.org" GOTOOLDIR="/usr/lib/golang/pkg/tool/linux_amd64" GCCGO="gccgo" AR="ar" CC="gcc" CXX="g++" CGO_ENABLED="1" GOMOD="/root/go/src/go.mod" CGO_CFLAGS="-g -O2" CGO_CPPFLAGS="" CGO_CXXFLAGS="-g -O2" CGO_FFLAGS="-g -O2" CGO_LDFLAGS="-g -O2" PKG_CONFIG="pkg-config" GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build549506781=/tmp/go-build -gno-record-gcc-switches"


ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/go/bin:/usr/lib/golang/bin