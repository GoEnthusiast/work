package middleware

import (
	commonRatelimitx "github.com/GoEnthusiast/gin-common/ratelimitx"
	commonRespx "github.com/GoEnthusiast/gin-common/responsex"
	"github.com/gin-gonic/gin"
)

func LimiterMiddleware(l commonRatelimitx.LimiterIface) gin.HandlerFunc {
	return func(ginCtx *gin.Context) {
		key := l.Key(ginCtx.Request)
		if bucket, ok := l.GetBucket(key); ok {
			count := bucket.TakeAvailable(1)
			if count == 0 {
				commonRespx.WriteJson(ginCtx, nil, commonRespx.CodeTooManyRequest)
				ginCtx.Abort()
				return
			}
		}
		ginCtx.Next()
	}
}
