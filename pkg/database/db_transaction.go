package database

import (
	"fmt"
	"strings"
)

type Transaction struct {
	ID          int     `json:"ID"`
	Name        string  `json:"Name"`
	ProjectName string  `json:"ProjectName"`
	Price       float64 `json:"Price"`
	PriceSQFT   float64 `json:"PriceSQFT"`
	Commission  float64 `json:"Commission"`
	Status      int     `json:"Status"`
	PayStatus   int     `json:"PayStatus"`
	Unit        string  `json:"Unit"`
	Location    string  `json:"Location"`
	Developer   string  `json:"Developer"`
	Description string  `json:"Description"`
	Appoint     string  `json:"Appoint"`
	Client      string  `json:"Client"`
	Agent       string  `json:"Agent"`
	SaleDate    string  `json:"SaleDate"`
	LaunchDate  string  `json:"LaunchDate"`
	CreateTime  string  `json:"CreateTime"`
}

type TransactionGetRequest struct {
	Name            string `json:"Name"`
	ProjectName     string `json:"ProjectName"`
	Status          int    `json:"Status"`
	PayStatus       int    `json:"PayStatus"`
	Unit            string `json:"Unit"`
	LaunchDateStart string `json:"LaunchDateStart"`
	LaunchDateEnd   string `json:"LaunchDateEnd"`
	SaleDateStart   string `json:"SaleDateStart"`
	SaleDateEnd     string `json:"SaleDateEnd"`
}

type TransactionEdit struct {
	Name        string  `json:"Name"`
	ProjectName string  `json:"ProjectName"`
	Price       float64 `json:"Price"`
	PriceSQFT   float64 `json:"PriceSQFT"`
	Commission  float64 `json:"Commission"`
	Status      int     `json:"Status"`
	PayStatus   int     `json:"PayStatus"`
	Unit        string  `json:"Unit"`
	Location    string  `json:"Location"`
	Developer   string  `json:"Developer"`
	Description string  `json:"Description"`
	Appoint     string  `json:"Appoint"`
	Client      string  `json:"Client"`
	Agent       string  `json:"Agent"`
	SaleDate    string  `json:"SaleDate"`
	LaunchDate  string  `json:"LaunchDate"`
}

var sqlTransactionGet = `SELECT * FROM Transaction %s;`

var sqlTransactionPOST = `
INSERT INTO Transaction (Name, ProjectName, Price, PriceSQFT, Commission,
	Status, PayStatus, Unit, Location, Developer, Description, Appoint,
	Client, Agent, SaleDate, LaunchDate)
VALUES ('%s', '%s', "%f", "%f", "%f", "%d", "%d", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s");
`
var sqlTransactionPUT = `
UPDATE Transaction
SET Name="%s", ProjectName="%s", Price="%f", PriceSQFT="%f", Commission="%f",
Status="%d", PayStatus="%d", Unit="%s", Location="%s", Developer="%s",
Description="%s", Appoint="%s", Client="%s", Agent="%s", SaleDate="%s", LaunchDate="%s";
`
var sqlTransactionDELETE = `DELETE FROM Transaction WHERE ID IN (%s);`

func (DB *SmartHubDB) TransactionGET(req TransactionGetRequest) ([]Transaction, string) {
	var Transactions []Transaction

	Querys := []string{}
	if req.Name != "" {
		Querys = append(Querys, fmt.Sprintf(`Name LIKE '%%%s%%'`, req.Name))
	}
	if req.ProjectName != "" {
		Querys = append(Querys, fmt.Sprintf(`ProjectName LIKE '%%%s%%'`, req.ProjectName))
	}
	if req.Status != -1 {
		Querys = append(Querys, fmt.Sprintf(`Status = %d`, req.Status))
	}
	if req.PayStatus != -1 {
		Querys = append(Querys, fmt.Sprintf(`PayStatus = %d`, req.PayStatus))
	}
	if req.Unit != "" {
		Querys = append(Querys, fmt.Sprintf(`Unit LIKE '%%%s%%'`, req.Unit))
	}
	if req.LaunchDateStart != "" && req.LaunchDateEnd != "" {
		Querys = append(Querys, fmt.Sprintf(`LaunchDate BETWEEN '%s' AND '%s'`, req.LaunchDateStart, req.LaunchDateEnd))
	}
	if req.SaleDateStart != "" && req.SaleDateEnd != "" {
		Querys = append(Querys, fmt.Sprintf(`SaleDate BETWEEN '%s' AND '%s'`, req.SaleDateStart, req.SaleDateEnd))
	}

	queryFilter := ""
	if len(Querys) == 1 {
		queryFilter = "WHERE " + Querys[0]
	} else if len(Querys) > 1 {
		queryFilter = "WHERE " + strings.Join(Querys, " AND ")
	}

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlTransactionGet, queryFilter))
	fmt.Println("###", fmt.Sprintf(sqlTransactionGet, queryFilter))
	if err != nil {
		return []Transaction{}, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var R Transaction

		Hits.Scan(
			&R.ID,
			&R.Name,
			&R.ProjectName,
			&R.Price,
			&R.PriceSQFT,
			&R.Commission,
			&R.Status,
			&R.PayStatus,
			&R.Unit,
			&R.Location,
			&R.Developer,
			&R.Description,
			&R.Appoint,
			&R.Client,
			&R.Agent,
			&R.SaleDate,
			&R.LaunchDate,
			&R.CreateTime,
		)

		fmt.Println(R)

		Transactions = append(Transactions, R)
	}

	return Transactions, ""
}

func (DB *SmartHubDB) TransactionPOST(m TransactionEdit) string {
	sql := fmt.Sprintf(
		sqlTransactionPOST,
		m.Name, m.ProjectName, m.Price, m.PriceSQFT, m.Commission,
		m.Status, m.PayStatus, m.Unit, m.Location, m.Developer,
		m.Description, m.Appoint, m.Client, m.Agent, m.SaleDate, m.LaunchDate,
	)

	fmt.Println(sql)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) TransactionPUT(m TransactionEdit) string {
	sql := fmt.Sprintf(
		sqlTransactionPUT,
		m.Name, m.ProjectName, m.Price, m.PriceSQFT, m.Commission,
		m.Status, m.PayStatus, m.Unit, m.Location, m.Developer,
		m.Description, m.Appoint, m.Client, m.Agent, m.SaleDate, m.LaunchDate,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) TransactionDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs {
		query += fmt.Sprintf(",%d", id)
	}

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlTransactionDELETE, query[1:]))

	if err != nil {
		return "Query failed"
	}

	return ""
}

func ValidTransaction(i TransactionEdit) (bool, TransactionEdit) {
	RET := i

	if RET.Name == "" || RET.ProjectName == "" {
		return false, RET
	}
	if RET.Price < 0 || RET.PriceSQFT < 0 {
		return false, RET
	}
	if RET.Commission < 0 || RET.Status < 0 || RET.PayStatus < 0 {
		return false, RET
	}
	if RET.Unit == "" || RET.Location == "" || RET.Developer == "" {
		return false, RET
	}
	if RET.Description == "" || RET.Appoint == "" || RET.Client == "" {
		return false, RET
	}
	if RET.Agent == "" || RET.SaleDate == "" || RET.LaunchDate == "" {
		return false, RET
	}

	return true, RET
}
