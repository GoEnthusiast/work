FROM golang:1.20

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置中文
ENV LANG C.UTF-8

WORKDIR /go
COPY {{.exefile}} .
COPY ./etc/* ./etc/
RUN chmod +x {{.exefile}}