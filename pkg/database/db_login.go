package database

import (
	"fmt"
)

func (DB *SmartHubDB) Try2Login(username, password string) (bool, string) {
	sql := fmt.Sprintf("SELECT `Password` FROM `Memeber` WHERE `Name`='%s';", username)

	Hits, err := DB.ctl.Query(sql)
    defer Hits.Close()

	if err != nil { return false, "Query failed" }

	hitPwd := ""
	for Hits.Next() {
		Hits.Scan(&hitPwd)
		break
	}

	if hitPwd == "" {
		return false, "Account not exist"
	}

	if hitPwd != password {
		return false, "Mismatch password"
	}

	return true, hitPwd
}