package database

import (
	"fmt"
	"strconv"
	"strings"
)

type FinancialData struct {
	Amount     int     `json:"Amount"`
	From       string  `json:"From"`
	To         string  `json:"To"`
	Revenue    float64 `json:"Revenue"`
	Commission float64 `json:"Commission"`
}

type Statistic struct {
	QueryConv   float64         `json:"QueryConv"`
	MonthConv   float64         `json:"MonthConv"`
	QueryRange  FinancialData   `json:"QueryRange"`
	MonthRange  FinancialData   `json:"MonthRange"`
	YearSummary []FinancialData `json:"YearSummary"`
}

var sqlSumAppointment = `SELECT Lead, Agent FROM Appointment WHERE AppointTime BETWEEN "%s" AND "%s";`
var sqlSumTransaction = `SELECT Price, Commission FROM Transaction WHERE SaleDate BETWEEN "%s" AND "%s";`

func (DB *SmartHubDB) GetRangeAppointment(from, to string) (float64, string) {
	var totalLead, totalAgent float64

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlSumAppointment, from, to))
	if err != nil {
		return 0, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var l, a string
		var numLead, numAgent float64

		Hits.Scan(&l, &a)

		if l == "" {
			numLead = 0
		} else {
			numLead = float64(strings.Count(l, ";") + 1)
		}

		if a == "" {
			numAgent = 0
		} else {
			numAgent = float64(strings.Count(a, ";") + 1)
		}

		totalLead += numLead
		totalAgent += numAgent
	}

	if totalAgent == 0 || totalLead == 0 {
		return 0, ""
	}

	return totalLead / totalAgent, ""
}

func (DB *SmartHubDB) GetRangeTransaction(from, to string) (FinancialData, string) {
	var totalRevenue, totalCommission float64
	var RangeData FinancialData

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlSumTransaction, from, to))
	if err != nil {
		return RangeData, "Query failed"
	}
	defer Hits.Close()

	count := 0
	for Hits.Next() {
		var r, c float64

		Hits.Scan(&r, &c)

		count++
		totalRevenue += r
		totalCommission += c
	}

	RangeData.Amount = count
	RangeData.From = from
	RangeData.To = to
	RangeData.Revenue = totalRevenue

	if count == 0 {
		RangeData.Commission = 0
	} else {
		RangeData.Commission = totalCommission / float64(count)
	}

	return RangeData, ""
}

func (DB *SmartHubDB) GetStatistic(queryFrom, queryTo string) (Statistic, string) {
	var StatisticData Statistic

	if len(queryFrom) < 10 || len(queryTo) < 10 {
		return StatisticData, "Invalid date format"
	}

	lastMonthStart, lastMonthEnd := SubMonth(queryFrom), SubMonth(queryTo)

	if queryConv, msg := DB.GetRangeAppointment(queryFrom, queryTo); msg == "" {
		StatisticData.QueryConv = queryConv
	} else {
		return StatisticData, msg
	}

	if monthConv, msg := DB.GetRangeAppointment(lastMonthStart, lastMonthEnd); msg == "" {
		StatisticData.MonthConv = monthConv
	} else {
		return StatisticData, msg
	}

	if queryRange, msg := DB.GetRangeTransaction(queryFrom, queryTo); msg == "" {
		StatisticData.QueryRange = queryRange
	} else {
		return StatisticData, msg
	}

	if monthRange, msg := DB.GetRangeTransaction(lastMonthStart, lastMonthEnd); msg == "" {
		StatisticData.MonthRange = monthRange
	} else {
		return StatisticData, msg
	}

	nowYear, _ := strconv.Atoi(queryFrom[:4])
	nowMonth, _ := strconv.Atoi(queryFrom[5:7])
	StatisticData.YearSummary = make([]FinancialData, 12)
	for i := 0; i < 12; i++ {
		realMonth := i + 1
		monthStart := fmt.Sprintf("%s-%02d-01", queryFrom[:4], realMonth)
		monthEnd := fmt.Sprintf("%s-%02d-31", queryFrom[:4], realMonth)

		if i > nowMonth {
			pastYear := nowYear - 1
			monthStart = fmt.Sprintf("%4d-%02d-01", pastYear, realMonth)
			monthEnd = fmt.Sprintf("%4d-%02d-31", pastYear, realMonth)
		}

		if monthRange, msg := DB.GetRangeTransaction(monthStart, monthEnd); msg == "" {
			StatisticData.YearSummary[i] = monthRange
		} else {
			return StatisticData, msg
		}
	}

	return StatisticData, ""
}

func SubMonth(input string) string {
	year, _ := strconv.Atoi(input[:4])
	month, _ := strconv.Atoi(input[5:7])

	if month == 1 {
		return fmt.Sprintf("%4d-%s-%s", year-1, "12", input[8:])
	}

	return fmt.Sprintf("%s-%02d-%s", input[:4], month-1, input[8:])
}
