## 本地环境编译+运行
```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build
docker build -t develop:{{.projectName}} .
docker stop {{.projectName}}
docker rm {{.projectName}}
rm -rf {{.projectName}}
docker run -it --privileged --restart=no --name {{.projectName}} --network {{.dockerNetWork}} develop:{{.projectName}}
```