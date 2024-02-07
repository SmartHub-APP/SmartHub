package database

import (
	"fmt"
	"strings"
)

type Appointment struct {
	ID          int    `json:"ID"`
	Status      int    `json:"Status"`
	Name        string `json:"Name"`
	ProjectName string `json:"ProjectName"`
	Lead        string `json:"Lead"`
	Agent       string `json:"Agent"`
	AppointTime string `json:"AppointTime"`
	CreateTime  string `json:"CreateTime"`
}

type AppointmentGetRequest struct {
	Name             string `json:"Name"`
	ProjectName      string `json:"ProjectName"`
	Status           int    `json:"Status"`
	AppointTimeStart string `json:"AppointTimeStart"`
	AppointTimeEnd   string `json:"AppointTimeEnd"`
}

type AppointmentGetResponse struct {
	ID          int          `json:"ID"`
	Status      int          `json:"Status"`
	Name        string       `json:"Name"`
	ProjectName string       `json:"ProjectName"`
	Lead        []MemberInfo `json:"Lead"`
	Agent       []MemberInfo `json:"Agent"`
	AppointTime string       `json:"AppointTime"`
}

type AppointmentPost struct {
	Status      int    `json:"Status"`
	Name        string `json:"Name"`
	ProjectName string `json:"ProjectName"`
	Lead        string `json:"Lead"`
	Agent       string `json:"Agent"`
	AppointTime string `json:"AppointTime"`
}

type AppointmentPUT struct {
	ID          int    `json:"ID"`
	Status      int    `json:"Status"`
	Name        string `json:"Name"`
	ProjectName string `json:"ProjectName"`
	Lead        string `json:"Lead"`
	Agent       string `json:"Agent"`
	AppointTime string `json:"AppointTime"`
}

var sqlAppointmentGet = `SELECT * FROM Appointment %s;`

var sqlAppointmentPOST = `
INSERT INTO Appointment (Status, Name, ProjectName, Lead, Agent, AppointTime)
VALUES ("%d", "%s", "%s", "%s", "%s", "%s");
`
var sqlAppointmentPUT = `
UPDATE Appointment
SET Status="%d", Name="%s", ProjectName="%s", Lead="%s", Agent="%s", AppointTime="%s"
WHERE ID="%d";
`
var sqlAppointmentDELETE = `DELETE FROM Appointment WHERE ID IN (%s);`

func (DB *SmartHubDB) AppointmentGET(req AppointmentGetRequest) ([]AppointmentGetResponse, string) {
	var Appointments []AppointmentGetResponse

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
	if req.AppointTimeStart != "" && req.AppointTimeEnd != "" {
		Querys = append(
			Querys,
			fmt.Sprintf(
				`AppointTime BETWEEN '%s' AND '%s'`,
				req.AppointTimeStart, req.AppointTimeEnd,
			),
		)
	}

	queryFilter := ""
	if len(Querys) == 1 {
		queryFilter = "WHERE " + Querys[0]
	} else if len(Querys) > 1 {
		queryFilter = "WHERE " + strings.Join(Querys, " AND ")
	}

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlAppointmentGet, queryFilter))
	if err != nil {
		return Appointments, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var R Appointment

		Hits.Scan(
			&R.ID, &R.Status, &R.Name, &R.ProjectName,
			&R.Lead, &R.Agent, &R.AppointTime, &R.CreateTime,
		)

		Leads, _ := DB.MemberGetByID(R.Lead)
		Clients, _ := DB.MemberGetByID(R.Agent)

		Appointments = append(
			Appointments, AppointmentGetResponse{
				ID:          R.ID,
				Status:      R.Status,
				Name:        R.Name,
				ProjectName: R.ProjectName,
				Lead:        Leads,
				Agent:       Clients,
				AppointTime: R.AppointTime,
			},
		)
	}

	return Appointments, ""
}

func (DB *SmartHubDB) AppointmentPOST(m AppointmentPost) string {
	sql := fmt.Sprintf(
		sqlAppointmentPOST,
		m.Status, m.Name, m.ProjectName, m.Lead, m.Agent, m.AppointTime,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) AppointmentPUT(m AppointmentPUT) string {
	sql := fmt.Sprintf(
		sqlAppointmentPUT,
		m.Status, m.Name, m.ProjectName, m.Lead, m.Agent, m.AppointTime,
		m.ID,
	)

	if _, err := DB.ctl.Exec(sql); err != nil {
		return "Query failed"
	}

	return ""
}

func (DB *SmartHubDB) AppointmentDELETE(IDs []int) string {
	query := ""

	for _, id := range IDs {
		query += fmt.Sprintf(",%d", id)
	}

	_, err := DB.ctl.Exec(fmt.Sprintf(sqlAppointmentDELETE, query[1:]))

	if err != nil {
		return "Query failed"
	}

	return ""
}
