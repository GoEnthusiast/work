## 本地环境编译+运行
```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build
docker build -t develop:{{.projectName}} .
rm -rf {{.projectName}}
docker stop {{.projectName}}
docker rm {{.projectName}}
docker run -it --privileged --restart=no --entrypoint="./{{.projectName}}" --name {{.projectName}} --network {{.dockerNetWork}} develop:{{.projectName}} -f ./etc/config.develop.yaml
```