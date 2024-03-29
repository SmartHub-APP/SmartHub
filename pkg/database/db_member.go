package database

import (
	"fmt"
	"strconv"
	"strings"
)

type Member struct {
	ID          int    `json:"ID"`
	Status      int    `json:"Status"`
	RoleID      int    `json:"RoleID"`
	Company     string `json:"Company"`
	JobTitle    string `json:"JobTitle"`
	Name        string `json:"Name"`
	Account     string `json:"Account"`
	Password    string `json:"Password"`
	Phone       string `json:"Phone"`
	BankCode    string `json:"BankCode"`
	BankAccount string `json:"BankAccount"`
	CreateTime  string `json:"CreateTime"`
}

type MemberInfo struct {
	ID          int    `json:"ID"`
	Role        Role   `json:"Role"`
	Name        string `json:"Name"`
	Company     string `json:"Company"`
	JobTitle    string `json:"JobTitle"`
	Account     string `json:"Account"`
	Phone       string `json:"Phone"`
	BankCode    string `json:"BankCode"`
	BankAccount string `json:"BankAccount"`
}

var sqlMemberGet = `
SELECT 
Member.ID,
Role.Name AS RoleName,
Role.Permission AS Permission,
Member.Name,
Member.Company,
Member.JobTitle,
Member.Account,
Member.Phone,
Member.BankCode,
Member.BankAccount
FROM Member
JOIN Role ON Member.RoleID = Role.ID
WHERE (Member.Status != 0) %s;
`
var sqlMemberGetQuery = `
AND (
	LOWER(Member.Company) LIKE '%%%s%%' OR
	LOWER(Member.Account) LIKE '%%%s%%' OR
	LOWER(Member.JobTitle) LIKE '%%%s%%' OR
	LOWER(Member.Name) LIKE '%%%s%%')
`
var sqlMemberPOST = `
INSERT INTO Member (Status, Name, Account, Password, RoleID, BankCode, BankAccount, Company, JobTitle, Phone)
VALUES ('%d', '%s', '%s', '%s', '%d', '%s', '%s', '%s', '%s', '%s');
`
var sqlMemberPUT = `
UPDATE Member
SET Status="%d", Name="%s", Account="%s", Password="%s", RoleID="%d",
BankCode="%s", BankAccount="%s", Company="%s", JobTitle="%s", Phone="%s"
WHERE ID="%d";
`
var sqlMemberDELETE = `DELETE FROM Member WHERE ID IN (%s);`
var sqlMemberCheck = `SELECT ID FROM Member WHERE Account="%s";`
var sqlGetMemberByID = `
SELECT 
Member.ID,
Role.Name AS RoleName,
Role.Permission AS Permission,
Member.Name,
Member.Company,
Member.JobTitle,
Member.Account,
Member.Phone,
Member.BankCode,
Member.BankAccount
FROM Member
JOIN Role ON Member.RoleID = Role.ID
WHERE (Member.Status != 0) AND (%s)`

func (DB *SmartHubDB) MemberGET(query, scheme string) ([]MemberInfo, string) {
	sRoleID, err := strconv.Atoi(scheme)
	if query == "" || sRoleID < -1 || err != nil {
		return []MemberInfo{}, "error input"
	}

	Members := []MemberInfo{}

	syntax := ""

	if sRoleID >= 0 {
		syntax += fmt.Sprintf(" AND (RoleID = %d)", sRoleID)
	}

	if lowerQuery := strings.ToLower(query); lowerQuery != "**" {
		syntax += fmt.Sprintf(
			sqlMemberGetQuery,
			lowerQuery,
			lowerQuery,
			lowerQuery,
			lowerQuery,
		)
	}

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlMemberGet, syntax))
	if err != nil {
		return []MemberInfo{}, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var R MemberInfo

		Hits.Scan(
			&R.ID,
			&R.Role.Name,
			&R.Role.Permission,
			&R.Name,
			&R.Company,
			&R.JobTitle,
			&R.Account,
			&R.Phone,
			&R.BankCode,
			&R.BankAccount,
		)

		Members = append(Members, R)
	}

	return Members, ""
}

func (DB *SmartHubDB) MemberPOST(m Member) string {
	sql := fmt.Sprintf(
		sqlMemberPOST,
		m.Status,
		m.Name,
		m.Account,
		m.Password,
		m.RoleID,
		m.BankCode,
		m.BankAccount,
		m.Company,
		m.JobTitle,
		m.Phone,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) MemberPUT(m Member) string {
	sql := fmt.Sprintf(
		sqlMemberPUT,
		m.Status,
		m.Name,
		m.Account,
		m.Password,
		m.RoleID,
		m.BankCode,
		m.BankAccount,
		m.Company,
		m.JobTitle,
		m.Phone,
		m.ID,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) MemberDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs {
		query += fmt.Sprintf(",%d", id)
	}

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlMemberDELETE, query[1:]))

	if err != nil {
		return "Query failed"
	}

	return ""
}

func ValidMember(i Member) (bool, Member) {
	RET := i

	trimName := strings.TrimSpace(i.Name)
	trimAccount := strings.TrimSpace(i.Account)
	trimPassword := strings.TrimSpace(i.Password)

	if i.ID == 0 || i.Status == 0 || i.RoleID == 0 {
		return false, RET
	}
	if trimName == "" || trimAccount == "" || trimPassword == "" {
		return false, RET
	}

	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}

func (DB *SmartHubDB) ValidMemberInsert(i Member) (string, Member) {
	RET := i

	trimName := strings.TrimSpace(i.Name)
	trimAccount := strings.TrimSpace(i.Account)

	if trimName == "" || trimAccount == "" {
		return "Missing field", RET
	}

	RET.Name, RET.Account = trimName, trimAccount

	alreadyExist := -1
	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlMemberCheck, trimAccount))
	if err != nil {
		return "Query failed", RET
	}
	defer Hits.Close()

	for Hits.Next() {
		Hits.Scan(&alreadyExist)
		break
	}

	if alreadyExist != -1 {
		return "Account already exist", RET
	}

	return "", RET
}

func (DB *SmartHubDB) MemberGetByID(query string) ([]MemberInfo, string) {
	Members := []MemberInfo{}
	Querys := []string{}

	for _, q := range strings.Split(query, ";") {
		Querys = append(Querys, fmt.Sprintf("Member.ID = %s", q))
	}

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlGetMemberByID, strings.Join(Querys, " OR ")))
	if err != nil {
		return Members, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var R MemberInfo

		Hits.Scan(
			&R.ID,
			&R.Role.Name,
			&R.Role.Permission,
			&R.Name,
			&R.Company,
			&R.JobTitle,
			&R.Account,
			&R.Phone,
			&R.BankCode,
			&R.BankAccount,
		)

		Members = append(Members, R)
	}

	return Members, ""
}
