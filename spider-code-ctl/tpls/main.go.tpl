package main

import (
	"flag"
	"{{.projectName}}/internal/config"
	"{{.projectName}}/internal/logic"
	"{{.projectName}}/internal/svc"
	commonConfigx "github.com/GoEnthusiast/gin-common/configx"
	commonLogx "github.com/GoEnthusiast/gin-common/logx"
)

var configFile = flag.String("f", "", "程序运行的配置文件")

func main() {
	flag.Parse()

	// 初始化配置文件
	var c config.Config
	commonConfigx.Init(*configFile, &c)

	// 初始化日志
	commonLogx.Init(c.Log.Level, c.Log.FileOut, c.Log.FileName, c.Log.MaxSize, c.Log.MaxBackups, c.Log.MaxAge, c.Log.Compress)

	// 初始化注射器
	ctx := svc.NewServiceContext(c)

    scriptLogic := logic.NewLogic(ctx)

    scriptLogic.Start()
}
