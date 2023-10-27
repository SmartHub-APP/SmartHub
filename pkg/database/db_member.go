package database

import (
	"fmt"
	"strings"
)

type Member struct {
	ID, Status, RoleID int
    Name, Account, Password, BankCode, BankAccount, CreateTime string
}

type MemberInsert struct {
	Status, RoleID int
    Name, Account, Password, BankCode, BankAccount string
}

var sqlMemberGet = `SELECT * FROM Member;`
var sqlMemberPOST = `
INSERT INTO Member (Status, Name, Account, Password, RoleID, BankCode, BankAccount)
VALUES ('%d', '%s', '%s', '%s', '%d', '%s', '%s');
`
var sqlMemberPUT = `
UPDATE Member
SET Name="%s", Account="%s", Password="%s", RoleID="%d", BankCode="%s", BankAccount="%s"
WHERE ID="%d";
`
var sqlMemberDELETE = `DELETE FROM Member WHERE ID IN (%s);`

func (DB *SmartHubDB) MemberGET() ([]Member, string) {
	var Members []Member

	Hits, err := DB.ctl.Query(sqlMemberGet)
    defer Hits.Close()

	if err != nil { return []Member{}, "Query failed" }

	for Hits.Next() {
		var R Member

		Hits.Scan(&R.ID, &R.Status, &R.Name, &R.Account, &R.Password, &R.RoleID, &R.BankCode, &R.BankAccount, &R.CreateTime)

		Members = append(Members, R)
	}

	return Members, ""
}

func (DB *SmartHubDB) MemberPOST(m MemberInsert) string {
	sql := fmt.Sprintf(sqlMemberPOST, m.Status, m.Name, m.Account, m.Password, m.RoleID, m.BankCode, m.BankAccount)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) MemberPUT(m Member) string {
	sql := fmt.Sprintf(sqlMemberPUT, m.Status, m.Name, m.Account, m.Password, m.RoleID, m.BankCode, m.BankAccount, m.ID)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) MemberDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs { query += fmt.Sprintf(",%d", id) }

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlMemberDELETE, query[1:]))

	if err != nil { return "Query failed" }

	return ""
}

func ValidMember(i Member) (bool, Member) {
    RET := i

	trimName     := strings.TrimSpace(i.Name)
    trimAccount  := strings.TrimSpace(i.Account)
    trimPassword := strings.TrimSpace(i.Password)

    if i.ID == 0 || i.Status == 0 || i.RoleID == 0 { return false, RET }
    if trimName == "" || trimAccount == "" || trimPassword == "" { return false, RET }
    
	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}

func ValidMemberInsert(i MemberInsert) (bool, MemberInsert) {
    RET := i

	trimName     := strings.TrimSpace(i.Name)
    trimAccount  := strings.TrimSpace(i.Account)
    trimPassword := strings.TrimSpace(i.Password)

    if i.Status == 0 || i.RoleID == 0 { return false, RET }
    if trimName == "" || trimAccount == "" || trimPassword == "" { return false, RET }
    
	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}