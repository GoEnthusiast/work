name: {{.projectName}}
host: 0.0.0.0
port: 9001
readTimeout: 60000
writeTimeout: 60000

log:
  level: info
  fileOut: true
  fileName: {{.projectName}}.log
  maxSize: 200        # 日志文件大小,单位M
  maxBackups: 7  # 日志文件备份数量
  maxAge: 30          # 日志文件保存时间,单位天
  compress: false      # 是否启用压缩

mysql:
  host: mysql
  port: 3306
  user: root
  password: 123456
  maxIdleConns: 100
  maxOpenConns: 200
  setConnMaxLifetime: 0
  dbName:

redis:
  host: redis
  port: 6379
  password:
  maxConns: 200
  db: 0

casbin:
  modelFile: etc/rbac_model.conf
  rulesTable: casbin_rbac_rules

passwordSalt: password-salt

jwt:
  secretKey: bef5219f-8548-f8ad-0e53-c886602cb451
  issuer: {{.projectName}}
  expire: 86400

# limiter 自定义定时定量限流
limiters:
  # 自定义加入该限流的路径
  - key: /demo
    # 间隔多久时间释放一次令牌桶，单位秒
    fillInterval: 60
    # 令牌捅的容量
    capacity: 150
    # 每次到达间隔时间后所释放的具体令牌数量
    quantum: 150
