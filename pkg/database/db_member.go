package database

import (
	"fmt"
	"strconv"
	"strings"
)

type Member struct {
	ID          int    `json:"id"`
	Status      int    `json:"status"`
	RoleID      int    `json:"role_id"`
	Company     string `json:"company"`
	JobTitle    string `json:"job_title"`
	Name        string `json:"name"`
	Account     string `json:"account"`
	Password    string `json:"password"`
	BankCode    string `json:"bank_code"`
	BankAccount string `json:"bank_account"`
	CreateTime  string `json:"create_time"`
}

/*
SELECT *
FROM Member
WHERE

	(role_id = [指定的role_id] OR [指定的role_id] IS NULL)
	AND (company LIKE '%[指定的特定字元1]%' OR '%[指定的特定字元1]%' IS NULL OR [指定的特定字元1] = '')
	AND (account LIKE '%[指定的特定字元2]%' OR '%[指定的特定字元2]%' IS NULL OR [指定的特定字元2] = '')
	AND (job_title LIKE '%[指定的特定字元3]%' OR '%[指定的特定字元3]%' IS NULL OR [指定的特定字元3] = '')
	AND (name LIKE '%[指定的特定字元4]%' OR '%[指定的特定字元4]%' IS NULL OR [指定的特定字元4] = '');

SELECT *
FROM Member
WHERE

	(role_id = OR IS NULL)
	AND (company LIKE '%[指定的特定字元1]%' OR '%[指定的特定字元1]%' IS NULL OR [指定的特定字元1] = '')
	AND (account LIKE '%[指定的特定字元2]%' OR '%[指定的特定字元2]%' IS NULL OR [指定的特定字元2] = '')
	AND (job_title LIKE '%[指定的特定字元3]%' OR '%[指定的特定字元3]%' IS NULL OR [指定的特定字元3] = '')
	AND (name LIKE '%[指定的特定字元4]%' OR '%[指定的特定字元4]%' IS NULL OR [指定的特定字元4] = '');
*/
var sqlMemberGet = `SELECT * FROM Member WHERE (Status != 0) %s;`
var sqlMemberGetQuery = `AND (
	LOWER(Company) LIKE '%%%s%%' OR
	LOWER(Account) LIKE '%%%s%%' OR
	LOWER(JobTitle) LIKE '%%%s%%' OR
	LOWER(Name) LIKE '%%%s%%')`
var sqlMemberPOST = `
INSERT INTO Member (Status, Name, Account, Password, RoleID, BankCode, BankAccount, Company, JobTitle)
VALUES ('%d', '%s', '%s', '%s', '%d', '%s', '%s', '%s', '%s');
`
var sqlMemberPUT = `
UPDATE Member
SET Status="%d", Name="%s", Account="%s", Password="%s", RoleID="%d", BankCode="%s", BankAccount="%s", Company="%s", JobTitle="%s"
WHERE ID="%d";
`
var sqlMemberDELETE = `DELETE FROM Member WHERE ID IN (%s);`

func (DB *SmartHubDB) MemberGET(query, scheme string) ([]Member, string) {
	sRoleID, err := strconv.Atoi(scheme)
	if query == "" || sRoleID < -1 || err != nil {
		return []Member{}, "error input"
	}

	Members := []Member{}

	syntax := ""

	if sRoleID >= 0 {
		syntax += fmt.Sprintf(" AND (RoleID = %d)", sRoleID)
	}

	if loqweQuery := strings.ToLower(query); loqweQuery != "**" {
		syntax += fmt.Sprintf(
			sqlMemberGetQuery,
			loqweQuery,
			loqweQuery,
			loqweQuery,
			loqweQuery,
		)
	}

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlMemberGet, syntax))
	defer Hits.Close()

	if err != nil {
		return []Member{}, "Query failed"
	}

	for Hits.Next() {
		var R Member

		Hits.Scan(
			&R.ID,
			&R.Status,
			&R.Company,
			&R.JobTitle,
			&R.Name,
			&R.Account,
			&R.Password,
			&R.RoleID,
			&R.BankCode,
			&R.BankAccount,
			&R.CreateTime,
		)

		Members = append(Members, R)
	}

	return Members, ""
}

func (DB *SmartHubDB) MemberPOST(m Member) string {
	sql := fmt.Sprintf(
		sqlMemberPOST,
		m.Status,
		m.Company,
		m.JobTitle,
		m.Name,
		m.Account,
		m.Password,
		m.RoleID,
		m.BankCode,
		m.BankAccount,
		m.Company,
		m.JobTitle,
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
		m.ID,
		m.Company,
		m.JobTitle,
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

func ValidMemberInsert(i Member) (bool, Member) {
	RET := i

	trimName := strings.TrimSpace(i.Name)
	trimAccount := strings.TrimSpace(i.Account)
	trimPassword := strings.TrimSpace(i.Password)

	if i.Status == 0 || i.RoleID == 0 {
		return false, RET
	}
	if trimName == "" || trimAccount == "" || trimPassword == "" {
		return false, RET
	}

	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}
