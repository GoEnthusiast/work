FROM golang:1.20

LABEL maintainer="WangYong <15711294367@163.com>"

ENV GOPROXY https://goproxy.cn,direct

# 安装必要的软件包和依赖包
USER root
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    zip \
    unzip \
    git \
    vim \
    screen

# 安装 goctl
USER root
RUN GOPROXY=https://goproxy.cn/,direct go install github.com/zeromicro/go-zero/tools/goctl@latest

# 安装 protoc
USER root
RUN curl -L -o /tmp/protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-linux-x86_64.zip && \
    unzip -d /tmp/protoc /tmp/protoc.zip && \
    mv /tmp/protoc/bin/protoc $GOPATH/bin

# 安装 protoc-gen-go
USER root
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# 安装 protoc-gen-go-grpc
USER root
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# $GOPATH/bin添加到环境变量中
ENV PATH $GOPATH/bin:$PATH

# 清理垃圾
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# 设置工作目录
WORKDIR /usr/src/code

EXPOSE 8000
EXPOSE 8001
EXPOSE 8002
EXPOSE 8003
EXPOSE 8004
EXPOSE 8005
EXPOSE 8006
EXPOSE 8007
EXPOSE 8008
EXPOSE 8009
EXPOSE 8010
EXPOSE 8011
EXPOSE 8012
EXPOSE 8013
EXPOSE 8014
EXPOSE 8015
EXPOSE 8016
EXPOSE 8017
EXPOSE 8018
EXPOSE 8019
EXPOSE 8020
EXPOSE 8021
EXPOSE 8022
EXPOSE 8023
EXPOSE 8024
EXPOSE 8025
EXPOSE 8026
EXPOSE 8027
EXPOSE 8028
EXPOSE 8029
EXPOSE 8030
EXPOSE 8031
EXPOSE 8032
EXPOSE 8033
EXPOSE 8034
EXPOSE 8035
EXPOSE 8036
EXPOSE 8037
EXPOSE 8038
EXPOSE 8039
EXPOSE 8040
EXPOSE 8041
EXPOSE 8042
EXPOSE 8043
EXPOSE 8044
EXPOSE 8045
EXPOSE 8046
EXPOSE 8047
EXPOSE 8048
EXPOSE 8049
EXPOSE 8050
EXPOSE 9000
EXPOSE 9001
EXPOSE 9002
EXPOSE 9003
EXPOSE 9004
EXPOSE 9005
EXPOSE 9006
EXPOSE 9007
EXPOSE 9008
EXPOSE 9009
EXPOSE 9010
EXPOSE 9011
EXPOSE 9012
EXPOSE 9013
EXPOSE 9014
EXPOSE 9015
EXPOSE 9016
EXPOSE 9017
EXPOSE 9018
EXPOSE 9019
EXPOSE 9020
EXPOSE 9021
EXPOSE 9022
EXPOSE 9023
EXPOSE 9024
EXPOSE 9025
EXPOSE 9026
EXPOSE 9027
EXPOSE 9028
EXPOSE 9029
EXPOSE 9030
EXPOSE 9031
EXPOSE 9032
EXPOSE 9033
EXPOSE 9034
EXPOSE 9035
EXPOSE 9036
EXPOSE 9037
EXPOSE 9038
EXPOSE 9039
EXPOSE 9040
EXPOSE 9041
EXPOSE 9042
EXPOSE 9043
EXPOSE 9044
EXPOSE 9045
EXPOSE 9046
EXPOSE 9047
EXPOSE 9048
EXPOSE 9049
EXPOSE 9050
