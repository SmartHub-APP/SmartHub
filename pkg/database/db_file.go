package database

import (
	"fmt"
)

type File struct {
	FileName string
	HashCode string
}

var sqlFileGET = `SELECT FileName, HashCode FROM File WHERE TransactionID=%s;`
var sqlFilePOST = `INSERT INTO File (TransactionID, FileName, HashCode) VALUES ('%s', '%s', '%s');`
var sqlFileDELETE = `DELETE FROM File WHERE HashCode='%s';`

func (DB *SmartHubDB) FileGET(TransactionID string) ([]File, string) {
	var Files []File

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlFileGET, TransactionID))

	if err != nil {
		return Files, "Query failed"
	}

	for Hits.Next() {
		var F File
		Hits.Scan(&F.FileName, &F.HashCode)
		Files = append(Files, F)
	}

	defer Hits.Close()

	return Files, ""
}

func (DB *SmartHubDB) FilePOST(TransactionID, FileName, HashCode string) string {
	sql := fmt.Sprintf(sqlFilePOST, TransactionID, FileName, HashCode)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) FileDELETE(HashCode string) string {
	sql := fmt.Sprintf(sqlFileDELETE, HashCode)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}
