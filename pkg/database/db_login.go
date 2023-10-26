package database

import (
	"fmt"
)

type LoginResult struct {
    Message    string
    Username   string
    Password   string
    Permission string
}

var sqlLogin = `
SELECT Member.Name, Member.Password, Role.Permission
FROM Member
INNER JOIN Role
ON Member.RoleID=Role.ID
WHERE Member.Account='%s'
`
var sqlGetNameAndPerm = `
SELECT Member.Name, Role.Permission
FROM Member
INNER JOIN Role
ON Member.RoleID=Role.ID
WHERE Member.Account='%s'
`

func (DB *SmartHubDB) Try2Login(account, password string) LoginResult {
	var lr LoginResult

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlLogin, account))
    defer Hits.Close()

	if err != nil {
		lr.Message = "Query failed"
		return lr
	}

	for Hits.Next() {
		Hits.Scan(
			&lr.Username,
			&lr.Password,
			&lr.Permission,
		)
		break
	}

	if lr.Password == "" {
		lr.Message = "Account not exist"
		return lr
	}

	if lr.Password != password {
		lr.Message = "Mismatch password"
		return lr
	}

	return lr
}

func (DB *SmartHubDB) GetNameAndPerm(account string) LoginResult {
	var lr LoginResult

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlGetNameAndPerm, account))
    defer Hits.Close()

	if err != nil {
		lr.Message = "Query failed"
		return lr
	}

	for Hits.Next() {
		Hits.Scan(
			&lr.Username,
			&lr.Permission,
		)
		break
	}

	return lr
}