package main

import (
	"flag"
	"{{.projectName}}/internal/config"
	"{{.projectName}}/internal/controller"
	"{{.projectName}}/internal/svc"
	commonConfigx "github.com/GoEnthusiast/gin-common/configx"
	commonLogx "github.com/GoEnthusiast/gin-common/logx"
	commonServerx "github.com/GoEnthusiast/gin-common/serverx"
)

var configFile = flag.String("f", "", "程序运行的配置文件")

func main() {
	flag.Parse()

	// 初始化配置文件
	var c config.Config
	commonConfigx.Init(*configFile, &c)

	// 初始化日志
	commonLogx.Init(c.Log.Level, c.Log.FileOut, c.Log.FileName, c.Log.MaxSize, c.Log.MaxBackups, c.Log.MaxAge, c.Log.Compress)

	// 创建服务
	server := commonServerx.NewServer(c.Host, c.Port, c.ReadTimeout, c.WriteTimeout)
	defer server.Close()

	// 初始化注射器
	ctx := svc.NewServiceContext(c)

	// 注册路由
	controller.Register(server, ctx)

	if err := server.ListenAndServe(); err != nil {
		panic(err)
	}
}
