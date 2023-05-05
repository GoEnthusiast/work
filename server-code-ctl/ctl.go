package main

import (
	"flag"
	"fmt"
	"os"
)

type Build struct {
	Path             string
	GoFileName       string
	TemplateFileName string
	Data             map[string]string
	Dir              bool
}

var projectName = flag.String("name", "", "the spider project name")
var templatePath = flag.String("home", "./tpls", "the spider go file template")

func main() {
	// 读取命令行参数
	flag.Parse()
	// 组合项目路径
	projectP := fmt.Sprintf("../code/%s", *projectName)
	// 创建项目文件夹
	createProjectDir(projectP)

	var builds []*Build
	builds = append(builds, &Build{Path: "etc", GoFileName: "config.develop.yaml", TemplateFileName: "config.develop.yaml.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "etc", GoFileName: "rbac_model.conf", TemplateFileName: "rbac_model.conf.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "internal/config", GoFileName: "config.go", TemplateFileName: "config.go.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "internal/controller", GoFileName: "controller.go", TemplateFileName: "controller.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/controller/demoController", GoFileName: "demoController.go", TemplateFileName: "demoController.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/dao/demoDao", GoFileName: "demoDao.go", TemplateFileName: "demoDao.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/logic/demoLogic", GoFileName: "demoLogic.go", TemplateFileName: "demoLogic.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/middleware", GoFileName: "ginDefaultMiddleware.go", TemplateFileName: "ginDefaultMiddleware.go.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "internal/middleware", GoFileName: "jwtMiddleware.go", TemplateFileName: "jwtMiddleware.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/middleware", GoFileName: "ratelimitMiddleware.go", TemplateFileName: "ratelimitMiddleware.go.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "internal/svc", GoFileName: "serviceContext.go", TemplateFileName: "serviceContext.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/model/demoModel", GoFileName: "demoModel.go", TemplateFileName: "demoModel.go.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "", GoFileName: "main.go", TemplateFileName: "main.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "common", GoFileName: "", TemplateFileName: "", Data: map[string]string{}, Dir: true})
	builds = append(builds, &Build{Path: "types", GoFileName: "", TemplateFileName: "", Data: map[string]string{}, Dir: true})

	for _, build := range builds {
		// 创建文件夹
		if err := os.MkdirAll(projectP+"/"+build.Path, 0775); err != nil {
			panic(err)
		}
		if !build.Dir {
			// 创建文件
			if err := genFiles(projectP, build.Path, build.GoFileName, build.TemplateFileName, build.Data); err != nil {
				panic(err)
			}
		}
	}

	// 执行go mod
	nowPath, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	if err = runCommand(nowPath+"/"+projectP, "go", "mod", "init", *projectName); err != nil {
		panic(err)
	}
	if err = runCommand(nowPath+"/"+projectP, "go", "mod", "tidy"); err != nil {
		panic(err)
	}
}
