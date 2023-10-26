package database

import (
	//"fmt"
)

type Role struct {
    Name string
	Perm string
}

var sqlGetRoles = `SELECT Name, Permission FROM Role;`

func (DB *SmartHubDB) GetRoles() ([]Role, string) {
	var Roles []Role

	Hits, err := DB.ctl.Query(sqlGetRoles)
    defer Hits.Close()

	if err != nil { return []Role{}, "Query failed" }

	for Hits.Next() {
		var R Role

		Hits.Scan(&R.Name, &R.Perm)

		Roles = append(Roles, R)
	}

	return Roles, ""
}
/*
func (DB *SmartHubDB) GetRoles() []Role, msg {
	var Roles []Role

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlGetRoles))
    defer Hits.Close()

	if err != nil { return [], "Query failed" }

	for Hits.Next() {
		var tmep Role

		Hits.Scan( &tmep.Name, &tmep.Perm )

		Roles = append(Roles, temp)
	}

	return Roles
}*/