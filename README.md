# work
需要在根目录创建code和data文件夹


## 使用
### 1. 按需修改 .env 配置
~~~env
# 设置时区
TZ=Asia/Shanghai
# 设置网络模式
NETWORKS_DRIVER=bridge


# PATHS ##########################################
# 宿主机上代码存放的目录路径
CODE_PATH_HOST=./code
# 宿主机上Mysql Reids数据存放的目录路径
DATA_PATH_HOST=./data


# MYSQL ##########################################
# Mysql 服务映射宿主机端口号，可在宿主机127.0.0.1:3306访问
MYSQL_PORT=3306
MYSQL_USERNAME=admin
MYSQL_PASSWORD=123456
MYSQL_ROOT_PASSWORD=123456


# REDIS ##########################################
# Redis 服务映射宿主机端口号，可在宿主机127.0.0.1:6379访问
REDIS_PORT=6379


# ETCD ###########################################
# Etcd 服务映射宿主机端口号，可在宿主机127.0.0.1:2379访问
ETCD_PORT=2379


# PROMETHEUS #####################################
# Prometheus 服务映射宿主机端口号，可在宿主机127.0.0.1:3000访问
PROMETHEUS_PORT=3000


# GRAFANA ########################################
# Grafana 服务映射宿主机端口号，可在宿主机127.0.0.1:4000访问
GRAFANA_PORT=4000


# JAEGER #########################################
# Jaeger 服务映射宿主机端口号，可在宿主机127.0.0.1:5000访问
JAEGER_PORT=5000


# DTM #########################################
# DTM HTTP 协议端口号
DTM_HTTP_PORT=36789
# DTM gRPC 协议端口号
DTM_GRPC_PORT=36790
~~~

### 2.启动服务
- 启动全部服务
```bash
docker-compose up -d
```
- 按需启动部分服务
```bash
docker-compose up -d etcd golang mysql redis
```

### 3.运行代码
将项目代码放置 `CODE_PATH_HOST` 指定的本机目录，进入 `golang` 容器，运行项目代码。
~~~bash
docker exec -it work-golang-1 bash
~~~

### 4. mysql读写分离配置
```sql
-- 注意事项：
    -- 1. 若master中存在老数据库与表，则需要在slave中手动创建库和表；
    -- 2. 若master中的表内存在老数据，则需要在slave中手动同步老数据；
    -- 3. 当master或slave重启后，需要从新配置CHANGE MASTER TO来建立同步关系；

-- 打开docker-compose中的mysql_slave配置    
-- 主mysql和从mysql中都执行如下命令，创建用于做数据同步用的user
CREATE USER 'replication'@'%' IDENTIFIED WITH mysql_native_password BY 'replication';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
ALTER USER 'replication'@'%' IDENTIFIED WITH mysql_native_password BY 'replication';

-- 主mysql中执行如下命令，查看文件名以及位置信息
SHOW MASTER STATUS;

-- 从mysql中执行如下命令，配置数据同步,根据主mysql中查询到的信息修改MASTER_LOG_FILE和MASTER_LOG_POS
CHANGE MASTER TO MASTER_HOST ='mysql', MASTER_USER ='replication', MASTER_PASSWORD ='replication', MASTER_LOG_FILE ='binlog.000020', MASTER_LOG_POS =487;
-- 从mysql中执行如下命令，启动数据同步
START SLAVE;

-- 从服务器命令列表
START SLAVE; -- 启动
STOP SLAVE; -- 停止
RESET SLAVE ALL; -- 初始化
SHOW SLAVE STATUS \G; -- 查看同步状态
```

### 5. 生成Gin后端项目代码
```shell
cd server-code-ctl
go build
./server-code-ctl -name 项目名称
```