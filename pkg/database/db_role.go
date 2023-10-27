package database

import (
	"fmt"
)

type Role struct {
    Name string
	Perm string
}

var sqlRoleGet = `SELECT Name, Permission FROM Role;`
var sqlRolePOST = `
INSERT INTO Role (Name, Permission)
SELECT '%s', '%s'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Role WHERE Name = '%s');
`

func (DB *SmartHubDB) RoleGET() ([]Role, string) {
	var Roles []Role

	Hits, err := DB.ctl.Query(sqlRoleGet)
    defer Hits.Close()

	if err != nil { return []Role{}, "Query failed" }

	for Hits.Next() {
		var R Role

		Hits.Scan(&R.Name, &R.Perm)

		Roles = append(Roles, R)
	}

	return Roles, ""
}

func (DB *SmartHubDB) RolePOST(name, perm string) string {
	_, err := DB.ctl.Exec(fmt.Sprintf(sqlRolePOST, name, perm, name))

	if err != nil { return "Query failed" }

	return ""
}