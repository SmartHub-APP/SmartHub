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

type TransactionGetResponse struct {
	ID          int          `json:"ID"`
	Name        string       `json:"Name"`
	ProjectName string       `json:"ProjectName"`
	Price       float64      `json:"Price"`
	PriceSQFT   float64      `json:"PriceSQFT"`
	Commission  float64      `json:"Commission"`
	Status      int          `json:"Status"`
	PayStatus   int          `json:"PayStatus"`
	Unit        string       `json:"Unit"`
	Location    string       `json:"Location"`
	Developer   string       `json:"Developer"`
	Description string       `json:"Description"`
	Appoint     []MemberInfo `json:"Appoint"`
	Client      []MemberInfo `json:"Client"`
	Agent       []MemberInfo `json:"Agent"`
	SaleDate    string       `json:"SaleDate"`
	LaunchDate  string       `json:"LaunchDate"`
}

type TransactionPost struct {
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

type TransactionPut struct {
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
Description="%s", Appoint="%s", Client="%s", Agent="%s", SaleDate="%s", LaunchDate="%s"
WHERE ID="%d";
`
var sqlTransactionDELETE = `DELETE FROM Transaction WHERE ID IN (%s);`

func (DB *SmartHubDB) TransactionGET(req TransactionGetRequest) ([]TransactionGetResponse, string) {
	var Transactions []TransactionGetResponse

	Querys := []string{}
	if req.Name != "" {
		Querys = append(Querys, fmt.Sprintf(`Name LIKE '%%%s%%'`, req.Name))
	}
	if req.ProjectName != "" {
		Querys = append(Querys, fmt.Sprintf(`ProjectName LIKE '%%%s%%'`, req.ProjectName))
	}
	if req.Status != 0 {
		Querys = append(Querys, fmt.Sprintf(`Status = %d`, req.Status))
	}
	if req.PayStatus != 0 {
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
	if err != nil {
		return Transactions, "Query failed"
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

		Appoints, _ := DB.MemberGetByID(R.Appoint)
		Clients, _ := DB.MemberGetByID(R.Client)
		Agents, _ := DB.MemberGetByID(R.Agent)

		Transactions = append(
			Transactions,
			TransactionGetResponse{
				ID:          R.ID,
				Name:        R.Name,
				ProjectName: R.ProjectName,
				Price:       R.Price,
				PriceSQFT:   R.PriceSQFT,
				Commission:  R.Commission,
				Status:      R.Status,
				PayStatus:   R.PayStatus,
				Unit:        R.Unit,
				Location:    R.Location,
				Developer:   R.Developer,
				Description: R.Description,
				Appoint:     Appoints,
				Client:      Clients,
				Agent:       Agents,
				SaleDate:    R.SaleDate,
				LaunchDate:  R.LaunchDate,
			},
		)
	}

	return Transactions, ""
}

func (DB *SmartHubDB) TransactionPOST(m TransactionPost) string {
	sql := fmt.Sprintf(
		sqlTransactionPOST,
		m.Name, m.ProjectName, m.Price, m.PriceSQFT, m.Commission,
		m.Status, m.PayStatus, m.Unit, m.Location, m.Developer,
		m.Description, m.Appoint, m.Client, m.Agent, m.SaleDate, m.LaunchDate,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) TransactionPUT(m TransactionPut) string {
	sql := fmt.Sprintf(
		sqlTransactionPUT,
		m.Name, m.ProjectName, m.Price, m.PriceSQFT, m.Commission,
		m.Status, m.PayStatus, m.Unit, m.Location, m.Developer,
		m.Description, m.Appoint, m.Client, m.Agent, m.SaleDate, m.LaunchDate,
		m.ID,
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
