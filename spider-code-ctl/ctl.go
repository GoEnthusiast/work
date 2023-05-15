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

var projectPath = flag.String("path", "", "the spider project path")
var projectName = flag.String("name", "", "the spider project name")
var cron = flag.Bool("cron", false, "Whether to use crontab")
var dockerNetWork = flag.String("network", "work_backend", "docker network")
var templatePath = flag.String("home", "./tpls", "the spider go file template")

func main() {
	// 读取命令行参数
	flag.Parse()
	// 组合项目路径
	projectP := fmt.Sprintf("../code/%s/%s", *projectPath, *projectName)
	// 创建项目文件夹
	createProjectDir(projectP)

	var builds []*Build
	builds = append(builds, &Build{Path: "etc", GoFileName: "config.develop.yaml", TemplateFileName: "config.develop.yaml.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/config", GoFileName: "config.go", TemplateFileName: "config.go.tpl", Data: map[string]string{}})
	builds = append(builds, &Build{Path: "internal/logic", GoFileName: "logic.go", TemplateFileName: "logic.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "internal/svc", GoFileName: "serviceContext.go", TemplateFileName: "serviceContext.go.tpl", Data: map[string]string{"projectName": *projectName}})
	builds = append(builds, &Build{Path: "", GoFileName: "main.go", TemplateFileName: "main.go.tpl", Data: map[string]string{"projectName": *projectName}})

	if *cron {
		builds = append(builds, &Build{Path: "", GoFileName: "cronjob", TemplateFileName: "cronjob.tpl", Data: map[string]string{"projectName": *projectName}})
		builds = append(builds, &Build{Path: "", GoFileName: "Dockerfile", TemplateFileName: "dockerfilecrom.tpl", Data: map[string]string{"exefile": *projectName}})
		builds = append(builds, &Build{Path: "", GoFileName: "README.md", TemplateFileName: "readmecron.tpl", Data: map[string]string{"projectName": *projectName, "dockerNetWork": *dockerNetWork}})
	} else {
		builds = append(builds, &Build{Path: "", GoFileName: "Dockerfile", TemplateFileName: "dockerfile.tpl", Data: map[string]string{"exefile": *projectName}})
		builds = append(builds, &Build{Path: "", GoFileName: "README.md", TemplateFileName: "readme.tpl", Data: map[string]string{"projectName": *projectName, "dockerNetWork": *dockerNetWork}})
	}

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
