package middleware

import (
	"{{.projectName}}/internal/svc"
	commonRespx "github.com/GoEnthusiast/gin-common/responsex"
	"github.com/gin-gonic/gin"
	"strings"
)

func JwtMiddleware(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		// 从请求头中获取jwt token
		token := ginCtx.Request.Header.Get("authorization")
		if token == "" {
			commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeUnauthorizedTokenNotExist)
			ginCtx.Abort()
			return
		}
		// 验证jwt
		clamis, err := svcCtx.Jwtx.ParseToken(token)
		if err != nil {
			if strings.Contains(err.Error(), "token is expired by") {
				commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeUnauthorizedTokenTimeout)
				ginCtx.Abort()
				return
			}
			if strings.Contains(err.Error(), "token contains an invalid number of segments") {
				commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeUnauthorizedTokenError)
				ginCtx.Abort()
				return
			}
			commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeServerError.WithDetails(err.Error()))
			ginCtx.Abort()
			return
		}
		ginCtx.Set("jwt", clamis)
		ginCtx.Next()
	}
}
