package middleware

import (
	"bytes"
	commonRsqx "github.com/GoEnthusiast/gin-common/requestx"
	"github.com/gin-gonic/gin"
	uuid2 "github.com/google/uuid"
	"go.uber.org/zap"
	"net"
	"net/http"
	"net/http/httputil"
	"os"
	"runtime/debug"
	"strings"
	"time"
)

type responseWriter struct {
	gin.ResponseWriter
	b *bytes.Buffer
}

func (w responseWriter) Write(b []byte) (int, error) {
	w.b.Write(b)
	return w.ResponseWriter.Write(b)
}

func GinLogger() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()

		// 从请求头中获取uuid, 如果没有就新创建一个
		var uuid string
		uuid = c.Request.Header.Get("X-Request-ID")
		if uuid == "" {
			uuid = uuid2.New().String()
		}

		// 包装c.Writer, 增加响应内容存储字段
		writer := responseWriter{
			c.Writer,
			bytes.NewBuffer([]byte{}),
		}
		c.Writer = writer

		// 响应头中设置uuid
		c.Header("X-Request-ID", uuid)

		path := c.Request.URL.Path
		pathQuery, _ := commonRsqx.ParsePathMap(c)
		formQuery, _ := commonRsqx.ParamFormMap(c)
		jsonQuery, _ := commonRsqx.ParamJsonMap(c)

		// 记录请求日志
		zap.L().Info("<Request Log>",
			zap.String("uuid", uuid),
			zap.String("ip", c.ClientIP()),
			zap.String("method", c.Request.Method),
			zap.String("path", path),
			zap.Any("pathQuery", pathQuery),
			zap.Any("formQuery", formQuery),
			zap.Any("jsonQuery", jsonQuery),
			zap.String("user-agent", c.Request.UserAgent()),
		)

		c.Next()

		// 检查响应字符长度, 若是长度超过1024, 则进行截断操作
		if writer.b.Len() > 1024 {
			writer.b.Truncate(1024)
		}

		// 记录响应日志
		cost := time.Since(start)
		zap.L().Info("<Response Log>",
			zap.String("uuid", uuid),
			zap.Int("status", c.Writer.Status()),
			zap.Any("resp", writer.b),
			zap.String("errors", c.Errors.ByType(gin.ErrorTypePrivate).String()),
			zap.Duration("cost", cost),
		)
	}
}

// GinRecovery recover掉项目可能出现的panic
func GinRecovery(stack bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// Check for a broken connection, as it is not really a
				// condition that warrants a panic stack trace.
				var brokenPipe bool
				if ne, ok := err.(*net.OpError); ok {
					if se, ok := ne.Err.(*os.SyscallError); ok {
						if strings.Contains(strings.ToLower(se.Error()), "broken pipe") || strings.Contains(strings.ToLower(se.Error()), "connection reset by peer") {
							brokenPipe = true
						}
					}
				}

				httpRequest, _ := httputil.DumpRequest(c.Request, false)
				if brokenPipe {
					zap.L().Error(c.Request.URL.Path,
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
					// If the connection is dead, we can't write a status to it.
					c.Error(err.(error)) // nolint: errcheck
					c.Abort()
					return
				}

				if stack {
					zap.L().Error("[Recovery from panic]",
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
						zap.String("stack", string(debug.Stack())),
					)
				} else {
					zap.L().Error("[Recovery from panic]",
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
				}
				c.AbortWithStatus(http.StatusInternalServerError)
			}
		}()
		c.Next()
	}
}
