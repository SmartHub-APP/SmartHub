package database

import (
	"fmt"
	"strings"
)

type Transactoin struct {
	ID, Status, RoleID int
    Name, Account, Password, BankCode, BankAccount, CreateTime string
}

type TransactoinInsert struct {
	Status, RoleID int
    Name, Account, Password, BankCode, BankAccount string
}

var sqlTransactoinGet = `SELECT * FROM Transactoin;`
var sqlTransactoinPOST = `
INSERT INTO Transactoin (Status, Name, Account, Password, RoleID, BankCode, BankAccount)
VALUES ('%d', '%s', '%s', '%s', '%d', '%s', '%s');
`
var sqlTransactoinPUT = `
UPDATE Transactoin
SET Status="%d", Name="%s", Account="%s", Password="%s", RoleID="%d", BankCode="%s", BankAccount="%s"
WHERE ID="%d";
`
var sqlTransactoinDELETE = `DELETE FROM Transactoin WHERE ID IN (%s);`

func (DB *SmartHubDB) TransactoinGET() ([]Transactoin, string) {
	var Transactoins []Transactoin

	Hits, err := DB.ctl.Query(sqlTransactoinGet)
    defer Hits.Close()

	if err != nil { return []Transactoin{}, "Query failed" }

	for Hits.Next() {
		var R Transactoin

		Hits.Scan(&R.ID, &R.Status, &R.Name, &R.Account, &R.Password, &R.RoleID, &R.BankCode, &R.BankAccount, &R.CreateTime)

		Transactoins = append(Transactoins, R)
	}

	return Transactoins, ""
}

func (DB *SmartHubDB) TransactoinPOST(m TransactoinInsert) string {
	sql := fmt.Sprintf(sqlTransactoinPOST, m.Status, m.Name, m.Account, m.Password, m.RoleID, m.BankCode, m.BankAccount)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) TransactoinPUT(m Transactoin) string {
	sql := fmt.Sprintf(sqlTransactoinPUT, m.Status, m.Name, m.Account, m.Password, m.RoleID, m.BankCode, m.BankAccount, m.ID)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) TransactoinDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs { query += fmt.Sprintf(",%d", id) }

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlTransactoinDELETE, query[1:]))

	if err != nil { return "Query failed" }

	return ""
}

func ValidTransactoin(i Transactoin) (bool, Transactoin) {
    RET := i

	trimName     := strings.TrimSpace(i.Name)
    trimAccount  := strings.TrimSpace(i.Account)
    trimPassword := strings.TrimSpace(i.Password)

    if i.ID == 0 || i.Status == 0 || i.RoleID == 0 { return false, RET }
    if trimName == "" || trimAccount == "" || trimPassword == "" { return false, RET }
    
	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}

func ValidTransactoinInsert(i TransactoinInsert) (bool, TransactoinInsert) {
    RET := i

	trimName     := strings.TrimSpace(i.Name)
    trimAccount  := strings.TrimSpace(i.Account)
    trimPassword := strings.TrimSpace(i.Password)

    if i.Status == 0 || i.RoleID == 0 { return false, RET }
    if trimName == "" || trimAccount == "" || trimPassword == "" { return false, RET }
    
	RET.Name, RET.Account, RET.Password = trimName, trimAccount, trimPassword

	return true, RET
}