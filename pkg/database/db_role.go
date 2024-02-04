package database

import (
	"fmt"
)

type Role struct {
	ID         int    `json:"ID"`
	Name       string `json:"Name"`
	Permission int    `json:"Permission"`
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
	if err != nil {
		return []Role{}, "Query failed"
	}
	defer Hits.Close()

	if err != nil {
		return []Role{}, "Query failed"
	}

	for Hits.Next() {
		var R Role

		Hits.Scan(&R.ID, &R.Name, &R.Permission)

		Roles = append(Roles, R)
	}

	return Roles, ""
}

func (DB *SmartHubDB) RolePOST(name, perm string) string {
	if _, err := DB.ctl.Exec(fmt.Sprintf(sqlRolePOST, name, perm)); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) RolePUT(name, perm string, id int) string {
	if _, err := DB.ctl.Exec(fmt.Sprintf(sqlRolePUT, name, perm, id)); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) RoleDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs {
		query += fmt.Sprintf(",%d", id)
	}

	if _, err := DB.ctl.Exec(fmt.Sprintf(sqlRoleDELETE, query[1:])); err != nil {
		return "Query failed"
	}

	return ""
}
