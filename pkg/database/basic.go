package database

import (
	"fmt"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	SmartHubTool "SmartHub/pkg/tool"
)

type SmartHubDB struct {
	ctl *sql.DB
}

const (
    maxOpenConns int = 10
    maxIdleConns int = 10
)

func (DB *SmartHubDB) Connection(cfg SmartHubTool.SettingConfig) (bool, string) {
	uri := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", cfg.DB_User, cfg.DB_Password, cfg.DB_Address, cfg.DB_Port, cfg.DB_Name)
	DB.ctl, _ = sql.Open("mysql", uri)

	if err := DB.ctl.Ping(); err != nil { return false, err.Error() }

	DB.ctl.SetMaxOpenConns(maxOpenConns)
	DB.ctl.SetMaxIdleConns(maxIdleConns)

	return true, "success"
}

func (DB *SmartHubDB) CheckTable(cfg SmartHubTool.SettingConfig) (bool, string) {
	_, isExist := DB.ctl.Query("select * from " + cfg.TB_User + ";")
    if isExist != nil { return false, isExist.Error() }

	_, isExist  = DB.ctl.Query("select * from " + cfg.TB_Role + ";")
    if isExist != nil { return false, isExist.Error() }

	_, isExist  = DB.ctl.Query("select * from " + cfg.TB_Transaction + ";")
    if isExist != nil { return false, isExist.Error() }

	_, isExist  = DB.ctl.Query("select * from " + cfg.TB_Appointment + ";")
    if isExist != nil { return false, isExist.Error() }

	return true, "success"
}