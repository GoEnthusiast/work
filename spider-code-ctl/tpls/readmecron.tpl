## 本地环境编译+运行
```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build
docker build --build-arg CRONJOB_FILE=./etc/cronjob.develop -t develop:{{.projectName}} .
docker stop {{.projectName}}
docker rm {{.projectName}}
rm -rf {{.projectName}}
docker run -it --privileged --restart=no --name {{.projectName}} --network {{.dockerNetWork}} develop:{{.projectName}}
```

## 测试环境编译
```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build
docker build --platform linux/amd64 --build-arg CRONJOB_FILE=./etc/cronjob.test -t registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.test .
docker push registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.test
rm -rf {{.projectName}}
```

## 测试环境运行
```shell
docker stop {{.projectName}}.test
docker rm {{.projectName}}.test
docker rmi registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.test
docker run -itd --privileged --restart=unless-stopped --name {{.projectName}}.test --network network-yyymobile-test registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.test
```

## 生产环境编译
```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build
docker build --platform linux/amd64 --build-arg CRONJOB_FILE=./etc/cronjob.prod -t registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.prod .
docker push registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.prod
rm -rf {{.projectName}}
```

## 生产环境运行
```shell
docker stop {{.projectName}}.prod
docker rm {{.projectName}}.prod
docker rmi registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.prod
docker run -itd --privileged --restart=unless-stopped --name {{.projectName}}.prod --network network-yyymobile-prod registry.cn-hangzhou.aliyuncs.com/yyy-mobile/spiders:{{.projectName}}.prod
```
