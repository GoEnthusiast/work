package demoController

import (
	"{{.projectName}}/internal/logic/demoLogic"
	"{{.projectName}}/internal/svc"
	"{{.projectName}}/types"
	commonRespx "github.com/GoEnthusiast/gin-common/responsex"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// DemoPingController
/*
	ping ~~ pong
	method: GET
	router: /demo/ping
	url: http://127.0.0.1:9001/demo/ping
*/
func DemoPingController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.Ping()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoLogController
/*
	使用日志
	method: GET
	router: /demo/log
	url: http://127.0.0.1:9001/demo/log
*/
func DemoLogController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.Log()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoErrorController
/*
	返回错误响应
	method: GET
	router: /demo/error
	url: http://127.0.0.1:9001/demo/error
*/
func DemoErrorController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.Error()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoMysqlController
/*
	使用mysql
*/
func DemoMysqlController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.Mysql()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoRedisController
/*
	使用redis
*/
func DemoRedisController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.Redis()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoStreamController
/*
	流式响应
*/
func DemoStreamController(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		if err := commonRespx.WriteStream(ginCtx, l.Stream); err != nil {
			zap.L().Error(err.Error())
		}
	}
}

// DemoJwtGenerate
/*
	生成jwt token
*/
func DemoJwtGenerate(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.JwtGenerate()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoJwtParse
/*
	解析jwt token
*/
func DemoJwtParse(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.JwtParse()
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}

// DemoParamVerify
/*
	参数解析
*/
func DemoParamVerify(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		var req types.DemoRequest
		// 参数验证
		if err := req.ParseGinContext(ginCtx); err != nil {
			zap.L().Error(err.Error())
			commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeInvalidParams.WithDetails(err.Error()))
			return
		}

		l := demoLogic.NewDemoLogic(svcCtx, ginCtx)
		resp, err := l.ParamVerify(&req)
		if err != nil {
			commonRespx.WriteJson(ginCtx, nil, err)
			return
		}
		commonRespx.WriteJson(ginCtx, resp, nil)
	}
}
