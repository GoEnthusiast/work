package demoLogic

import (
    "fmt"
	"{{.projectName}}/internal/svc"
	"{{.projectName}}/types"
	commonRespx "github.com/GoEnthusiast/gin-common/responsex"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"time"
)

func NewDemoLogic(svcCtx *svc.ServiceContext, ginCtx *gin.Context) *DemoLogic {
	return &DemoLogic{
		svcCtx: svcCtx,
		ginCtx: ginCtx,
	}
}

type DemoLogic struct {
	svcCtx *svc.ServiceContext
	ginCtx *gin.Context
}

func (l *DemoLogic) Ping() (string, *commonRespx.E) {
	return "pong", nil
}

func (l *DemoLogic) Log() (string, *commonRespx.E) {
	zap.L().Debug("这是debug级别日志.")
	zap.L().Info("这是info级别日志.")
	zap.L().Error("这是error级别日志.")
	// 其它日志级别参考zap文档
	return "", nil
}

func (l *DemoLogic) Error() (string, *commonRespx.E) {
	/*
		CodeSuccess                   = NewCode(10000, "成功")
		CodeInvalidParams             = NewCode(10001, "参数错误")
		CodeServerError               = NewCode(10002, "服务器内部错误")
		CodeTooManyRequest            = NewCode(10003, "请求次数过多")
		CodeUnauthorizedSignError     = NewCode(10004, "sign错误")
		CodeUnauthorizedSignTimeout   = NewCode(10005, "sign过期")
		CodeUnauthorizedSignNotExist  = NewCode(10006, "sign缺失")
		CodeMessageError              = NewCode(10007, "Message Error")
		CodeUnauthorizedTokenError    = NewCode(10008, "token错误")
		CodeUnauthorizedTokenTimeout  = NewCode(10009, "token过期")
		CodeUnauthorizedTokenNotExist = NewCode(100010, "token缺失")
		更多code模板查看: github.com/GoEnthusiast/gin-common/responsex/code
	*/
	return "", commonRespx.CodeMessageError.WithDetails("这是返回的自定义错误信息")
}

func (l *DemoLogic) Mysql() (any, *commonRespx.E) {
	result, err := l.svcCtx.DemoDao.FindOne(1)
	if err != nil {
		return nil, commonRespx.CodeServerError.WithDetails(err.Error())
	}
	return result, nil
}

func (l *DemoLogic) Redis() (any, *commonRespx.E) {
	result, err := l.svcCtx.DemoDao.GetValue("demo")
	if err != nil {
		return nil, commonRespx.CodeServerError.WithDetails(err.Error())
	}
	return result, nil
}

func (l *DemoLogic) Stream(ch *chan []byte, args ...any) {
	defer close(*ch)
	userData := "我是一名资深程序员，具有丰富的软件开发经验和卓越的编程技能。我热爱编程，对新兴技术和编程语言都有着极大的兴趣。\n\n"
	for _, v := range userData {
		*ch <- []byte(string(v))
		time.Sleep(100 * time.Millisecond)
	}
}

func (l *DemoLogic) JwtGenerate() (any, *commonRespx.E) {
	userId := 1
	token, err := l.svcCtx.Jwtx.GenerateToke(int64(userId))
	if err != nil {
		return nil, commonRespx.CodeServerError.WithDetails(err.Error())
	}
	return token, nil
}

func (l *DemoLogic) JwtParse() (any, *commonRespx.E) {
	token := l.ginCtx.Request.Header.Get("authorization")
	clamis, err := l.svcCtx.Jwtx.ParseToken(token)
	if err != nil {
		return nil, commonRespx.CodeServerError.WithDetails(err.Error())
	}
	return clamis, nil
}

func (l *DemoLogic) ParamVerify(req *types.DemoRequest) (any, *commonRespx.E) {
	zap.L().Info(fmt.Sprintf("%d", req.UserID))
	zap.L().Info(req.UserName)
	return map[string]string{"msg": "demo"}, nil
}