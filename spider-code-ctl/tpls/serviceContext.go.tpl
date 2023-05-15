package svc

import (
	"fmt"
	"{{.projectName}}/internal/config"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/redis/go-redis/v9"
	"github.com/wangyong321/gogorequest"
	"time"
)

type ServiceContext struct {
	Config            config.Config // 配置文件
	Sqlx              *sqlx.DB
	Redisx            *redis.Client
	Requests          *gogorequest.SyncEngine
}

func NewServiceContext(c config.Config) *ServiceContext {
	// mysql
	mysqlConn := sqlx.MustConnect("mysql", fmt.Sprintf(
		"%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True",
		c.Mysql.User, c.Mysql.Password, c.Mysql.Host, c.Mysql.Port, c.Mysql.DbName,
	))
	mysqlConn.SetMaxOpenConns(c.Mysql.MaxOpenConns)
	mysqlConn.SetMaxIdleConns(c.Mysql.MaxIdleConns)
	mysqlConn.SetConnMaxLifetime(time.Duration(c.Mysql.SetConnMaxLifetime))

	// redis
	redisConn := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", c.Redis.Host, c.Redis.Port),
		Password: c.Redis.Password,
		DB:       c.Redis.DB,
		PoolSize: c.Redis.MaxConns,
	})

	return &ServiceContext{
		Config:            c,
		Sqlx:              mysqlConn,
		Redisx:            redisConn,
		Requests:          gogorequest.NewSyncEngine(),
	}
}
