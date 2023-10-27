package database

import (
	"fmt"
)

var sqlFilePOST = `INSERT INTO File (TransactionID, FileName, HashCode) VALUES ('%s', '%s', '%s');`
var sqlFileDELETE = `DELETE FROM File WHERE HashCode='%s';`

func (DB *SmartHubDB) FilePOST(TransactionID, FileName, HashCode string) string {
	sql := fmt.Sprintf(sqlFilePOST, TransactionID, FileName, HashCode)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}

func (DB *SmartHubDB) FileDELETE(HashCode string) string {
	sql := fmt.Sprintf(sqlFileDELETE, HashCode)

	if _, err := DB.ctl.Exec(sql); err != nil { return "Query failed" }

	return ""
}