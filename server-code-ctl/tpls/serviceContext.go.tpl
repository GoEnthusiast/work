package svc

import (
	"fmt"
	"{{.projectName}}/internal/config"
	"{{.projectName}}/internal/dao/demoDao"
	commonCasbinx "github.com/GoEnthusiast/gin-common/casbinx"
	commonJwtx "github.com/GoEnthusiast/gin-common/jwtx"
	commonRatelimitx "github.com/GoEnthusiast/gin-common/ratelimitx"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/redis/go-redis/v9"
	"time"
)

type ServiceContext struct {
	Config            config.Config // 配置文件
	Sqlx              *sqlx.DB
	Redisx            *redis.Client
	Casbinx           *commonCasbinx.Casbinx
	Jwtx              *commonJwtx.JWT
	LimiterMiddleware commonRatelimitx.LimiterIface
	DemoDao           *demoDao.DemoDao
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

	// 桶装限流器
	limiter := commonRatelimitx.NewMethodLimiter(c.Limiters)

	// casbin
	casbinx := commonCasbinx.NewCasbinx(mysqlConn.DB, c.Casbin.ModelFile, c.Casbin.RulesTable)
	return &ServiceContext{
		Config:            c,
		Sqlx:              mysqlConn,
		Redisx:            redisConn,
		Casbinx:           casbinx,
		LimiterMiddleware: limiter,
		DemoDao:           demoDao.NewDemoDao(c, mysqlConn, redisConn),
		Jwtx:              commonJwtx.NewJWTEngine(c.Jwt.SecretKey, c.Jwt.Issuer, time.Duration(c.Jwt.Expire)*time.Second),
	}
}
