package demoModel

import (
	"fmt"
	commonSlicex "github.com/GoEnthusiast/gin-common/golangx/slicex"
	commonStructx "github.com/GoEnthusiast/gin-common/golangx/structx"
	"golang.org/x/crypto/scrypt"
	"strings"
	"time"
)

// DemoModel
/*
CREATE TABLE `user` (
	`id` int NOT NULL AUTO_INCREMENT COMMENT '主键,用作admin账号的id',
	`account` varchar(50) NOT NULL COMMENT 'admin账号',
	`password` varchar(255) NOT NULL COMMENT 'admin密码',
	`username` varchar(50) NOT NULL COMMENT '用户名',
	`type` varchar(10) NOT NULL DEFAULT 'slave' COMMENT '账号类型',
	`create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
	`update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据更新时间',
	`del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除,0正常,1已删除',
	PRIMARY KEY (`id`),
	UNIQUE KEY `account_UNIQUE` (`account`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
*/
type DemoModel struct {
	ID       int64     `json:"id" db:"id"`
	Account  string    `json:"account" db:"account"`
	Password string    `json:"password" db:"password"`
	Username string    `json:"username" db:"username"`
	Type     string    `json:"type" db:"type"`
	CreateAt time.Time `json:"create_at" db:"create_at"`
	UpdateAt time.Time `json:"update_at" db:"update_at"`
	Del      int8      `json:"del" db:"del"`
}

func (m *DemoModel) TableName() string {
	return "admin"
}

func (m *DemoModel) TagValues() []string {
	tagValues, _ := commonStructx.GetTagValues(m, "db")
	return tagValues
}

func (m *DemoModel) InsertFields() string {
	return strings.Join(commonSlicex.RemoveStringFields(m.TagValues(), "`id`", "`create_at`", "`update_at`", "`del`"), ",")
}

func (m *DemoModel) UpdateFields() string {
	return strings.Join(commonSlicex.RemoveStringFields(m.TagValues(), "`id`", "`account`", "`create_at`", "`update_at`"), "=?,") + "=?"
}

func (m *DemoModel) EncryPassword(salt string) {
	dk, _ := scrypt.Key([]byte(m.Password), []byte(salt), 32768, 8, 1, 32)
	m.Password = fmt.Sprintf("%x", string(dk))
}
