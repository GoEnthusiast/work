package demoDao

import (
	"context"
	"fmt"
	"{{.projectName}}/internal/config"
	"{{.projectName}}/internal/model/demoModel"
	"github.com/jmoiron/sqlx"
	"github.com/redis/go-redis/v9"
)

func NewDemoDao(c config.Config, mysqlConn *sqlx.DB, redisConn *redis.Client) *DemoDao {
	return &DemoDao{
		c:         c,
		mysqlConn: mysqlConn,
		redisConn: redisConn,
	}
}

type DemoDao struct {
	c         config.Config
	mysqlConn *sqlx.DB
	redisConn *redis.Client
}

func (d *DemoDao) FindOne(userID int64) (*demoModel.DemoModel, error) {
	userModel := demoModel.DemoModel{}
	query := fmt.Sprintf("SELECT * FROM %s WHERE `id` = ?", userModel.TableName())
	err := d.mysqlConn.Get(&userModel, query, userID)
	if err != nil {
		return nil, err
	}
	return &userModel, nil
}

func (d *DemoDao) GetValue(key string) (string, error) {
	ctx := context.Background()
	result := d.redisConn.Get(ctx, key).Val()
	return result, nil
}
