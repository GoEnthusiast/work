package logic

import (
	"{{.projectName}}/internal/svc"
)

type Logic struct {
	svcCtx *svc.ServiceContext
}

func NewLogic(ctx *svc.ServiceContext) *Logic {
	return &Logic{
		svcCtx: ctx,
	}
}

// Start
/*
    targetUrl := "https://httpbin.org/get"
    headers := map[string]string{
    	"Content-Type": "application/json",
    }
    resp := l.svcCtx.Requests.Visit("GET", targetUrl, headers, nil, 30, "", nil)
    if resp.StatusCode != 200 {
    	zap.L().Error(fmt.Sprintf("status code error: %d", resp.StatusCode))
    	return
    }
    if resp.Error != nil {
    	zap.L().Error(fmt.Sprintf("response error: %s", resp.Error.Error()))
    	return
    }
    zap.L().Info(resp.Text)
*/
func (l *Logic) Start() {
	// TODO Write your program
}
