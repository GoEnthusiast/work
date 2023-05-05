package controller

import (
	"{{.projectName}}/internal/controller/demoController"
	"{{.projectName}}/internal/middleware"
	"{{.projectName}}/internal/svc"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Register(s *http.Server, svcCtx *svc.ServiceContext) {
	r := gin.New()
	r.Use(
		middleware.GinLogger(),
		middleware.GinRecovery(true),
		middleware.LimiterMiddleware(svcCtx.LimiterMiddleware),
	)

	// Demo
	r.GET("/demo/ping", demoController.DemoPingController(svcCtx))
	r.GET("/demo/log", demoController.DemoLogController(svcCtx))
	r.GET("/demo/error", demoController.DemoErrorController(svcCtx))
	r.GET("/demo/mysql", demoController.DemoMysqlController(svcCtx))
	r.GET("/demo/redis", demoController.DemoRedisController(svcCtx))
	r.GET("/demo/stream", demoController.DemoStreamController(svcCtx))
	r.GET("/demo/jwt/generate", demoController.DemoJwtGenerate(svcCtx))
	r.POST("/demo/jwt/parse", demoController.DemoJwtParse(svcCtx))

	s.Handler = r
}
