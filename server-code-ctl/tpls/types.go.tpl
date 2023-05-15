package types

import "github.com/gin-gonic/gin"

type DemoRequest struct {
	UserID   int64  `json:"user_id" binding:"required"`
	UserName string `json:"user_name" binding:"required,min=6,max=10"`
}

func (t *DemoRequest) ParseGinContext(ginCtx *gin.Context) error {
	return ginCtx.ShouldBindJSON(t)
}