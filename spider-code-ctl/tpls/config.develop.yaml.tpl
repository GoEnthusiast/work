# 爬虫名称
name: {{.projectName}}

log:
  level: info
  fileOut: true
  fileName: /root/static/{{.projectName}}.log
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
