FROM golang:1.20

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置中文
ENV LANG C.UTF-8

# 安装 cron
RUN apt-get update && apt-get install -y cron && apt-get -y install vim

WORKDIR /go
COPY {{.exefile}} .
COPY ./etc/* ./etc/

ARG CRONJOB_FILE
COPY ${CRONJOB_FILE} /etc/cron.d/cronjob

RUN chmod +x {{.exefile}}
RUN chmod 0644 /etc/cron.d/cronjob
RUN crontab /etc/cron.d/cronjob
RUN mkdir /root/static
RUN touch /root/static/{{.exefile}}.log

CMD service cron start && tail -f /root/static/{{.exefile}}.log