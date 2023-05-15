package main

import (
	"bytes"
	"errors"
	"fmt"
	goformat "go/format"
	"os"
	"os/exec"
	"strings"
	"text/template"
)

// createProjectDir
/*
	创建项目文件夹
*/
func createProjectDir(p string) {
	if err := os.MkdirAll(p, 0775); err != nil {
		panic(err)
	}
}

type genFileData struct {
	goFilePath       string
	goFileName       string
	templatePath     string
	templateFileName string
	data             any
}

// 创建文件
func genFiles(projectPath, goFilePath, goFile, templateFile string, data map[string]string) error {
	return tplToGo(genFileData{
		goFilePath:       projectPath + "/" + goFilePath,
		goFileName:       goFile,
		templatePath:     *templatePath,
		templateFileName: templateFile,
		data:             data,
	})
}

func tplToGo(c genFileData) error {
	// 读取模板文件
	tpContext, err := readTplFile(c.templatePath + "/" + c.templateFileName)
	if err != nil {
		return err
	}
	// 创建go文件
	fp, err := createGoFile(c.goFilePath + "/" + c.goFileName)
	if err != nil {
		if strings.Contains(err.Error(), "is exist") {
			return nil
		}
		return err
	}
	// 写入模板程序到go文件
	t := template.Must(template.New("").Parse(tpContext))
	buffer := new(bytes.Buffer)
	err = t.Execute(buffer, c.data)
	if err != nil {
		return err
	}

	code := formatCode(buffer.String())
	_, err = fp.WriteString(code)
	return err
}

func formatCode(code string) string {
	ret, err := goformat.Source([]byte(code))
	if err != nil {
		return code
	}

	return string(ret)
}

// createGoFile
/*
	创建go文件
*/
func createGoFile(file string) (*os.File, error) {
	// 检查文件是否存在
	exist := fileExist(file)
	if exist {
		fmt.Println(fmt.Sprintf("%s is exist.", file))
		return nil, errors.New(fmt.Sprintf("%s is exist.", file))
	}
	return os.Create(file)
}

// fileExist
/*
	检查文件是否存在
*/
func fileExist(file string) bool {
	if _, err := os.Stat(file); os.IsNotExist(err) {
		return false
	}
	return true
}

// readTplFile
/*
	读取模板文件内容
*/
func readTplFile(file string) (string, error) {
	// 检查文件是否存在
	exist := fileExist(file)
	if !exist {
		return "", errors.New(fmt.Sprintf("%s is not exist!", file))
	}
	// 读取tpl文件内容
	content, err := os.ReadFile(file)
	if err != nil {
		return "", err
	}
	return string(content), nil
}

func runCommand(dir string, name string, args ...string) error {
	// 创建命令
	cmd := exec.Command(name, args...)
	cmd.Dir = dir

	// 将命令输入直接输出到终端
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	// 运行命令并返回错误
	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
