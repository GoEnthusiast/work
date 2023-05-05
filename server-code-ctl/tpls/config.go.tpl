package config

import commonRatelimitx "github.com/GoEnthusiast/gin-common/ratelimitx"

type Config struct {
	Name         string `mapstructure:"name"`
	Host         string `mapstructure:"host"`
	Port         int    `mapstructure:"port"`
	ReadTimeout  int    `mapstructure:"readTimeout"`
	WriteTimeout int    `mapstructure:"writeTimeout"`

	Log struct {
		Level      string `mapstructure:"level"`
		FileOut    bool   `mapstructure:"fileOut"`
		FileName   string `mapstructure:"fileName"`
		MaxSize    int    `mapstructure:"maxSize"`
		MaxBackups int    `mapstructure:"maxBackups"`
		MaxAge     int    `mapstructure:"maxAge"`
		Compress   bool   `mapstructure:"compress"`
	} `mapstructure:"log"`

	Mysql struct {
		Host               string `mapstructure:"host"`
		Port               int    `mapstructure:"port"`
		User               string `mapstructure:"user"`
		Password           string `mapstructure:"password"`
		MaxIdleConns       int    `mapstructure:"maxIdleConns"`
		MaxOpenConns       int    `mapstructure:"maxOpenConns"`
		SetConnMaxLifetime int    `mapstructure:"setConnMaxLifetime"`
		DbName             string `mapstructure:"dbName"`
	} `mapstructure:"mysql"`

	Redis struct {
		Host     string `mapstructure:"host"`
		Port     int    `mapstructure:"port"`
		Password string `mapstructure:"password"`
		MaxConns int    `mapstructure:"maxConns"`
		DB       int    `mapstructure:"db"`
	} `mapstructure:"redis"`

	Casbin struct {
		ModelFile  string `json:"modelFile"`
		RulesTable string `json:"rulesTable"`
	} `json:"casbin"`

	PasswordSalt string `json:"passwordSalt"`

	Jwt struct {
		SecretKey string `json:"secretKey"`
		Issuer    string `json:"issuer"`
		Expire    int64  `json:"expire"`
	} `json:"jwt"`

	Limiters []commonRatelimitx.LimiterInfo `json:"limiters"`
}
