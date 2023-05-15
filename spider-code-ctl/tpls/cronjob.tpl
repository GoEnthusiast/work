# 开发环境
* * * * * root /go/{{.projectName}} -f /go/etc/config.develop.yaml > /dev/null 2>&1

# 测试环境
# * * * * * root /go/{{.projectName}} -f /go/etc/config.test.yaml > /dev/null 2>&1

# 生产环境
# * * * * * root /go/{{.projectName}} -f /go/etc/config.prod.yaml > /dev/null 2>&1