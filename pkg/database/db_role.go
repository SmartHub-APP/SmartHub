package database

import (
	"fmt"
)

type Role struct {
	ID int
    Name string
	Perm string
}

var sqlRoleGet = `SELECT * FROM Role;`
var sqlRolePOST = `
INSERT INTO Role (Name, Permission)
VALUES ('%s', '%s');
`
var sqlRolePUT = `
UPDATE Role
SET Name="%s", Permission="%s"
WHERE ID="%d";
`
var sqlRoleDELETE = `DELETE FROM Role WHERE ID IN (%s);`

func (DB *SmartHubDB) RoleGET() ([]Role, string) {
	var Roles []Role

	Hits, err := DB.ctl.Query(sqlRoleGet)
    defer Hits.Close()

	if err != nil { return []Role{}, "Query failed" }

	for Hits.Next() {
		var R Role

		Hits.Scan(&R.ID, &R.Name, &R.Perm)

		Roles = append(Roles, R)
	}

	return Roles, ""
}

func (DB *SmartHubDB) RolePOST(name, perm string) string {
	_, err := DB.ctl.Exec(fmt.Sprintf(sqlRolePOST, name, perm))

	if err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) RolePUT(name, perm string, id int) string {
	_, err := DB.ctl.Exec(fmt.Sprintf(sqlRolePUT, name, perm, id))

	if err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) RoleDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs { query += fmt.Sprintf(",%d", id) }

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlRoleDELETE, query[1:]))

	if err != nil { return "Query failed" }

	return ""
}