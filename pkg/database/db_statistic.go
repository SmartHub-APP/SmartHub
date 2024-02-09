package database

import (
	"fmt"
	"strconv"
)

type FinancialData struct {
	Revenue    float64 `json:"Revenue"`
	Commission float64 `json:"Commission"`
}

type Statistic struct {
	QueryRange  FinancialData   `json:"QueryRange"`
	MonthRange  FinancialData   `json:"MonthRange"`
	YearSummary []FinancialData `json:"YearSummary"`
}

var sqlGetRange = `SELECT Price, Commission FROM Transaction WHERE SaleDate BETWEEN "%s" AND "%s";`

func (DB *SmartHubDB) GetRangeData(from, to string) (FinancialData, string) {
	var totalRevenue, totalCommission float64
	var RangeData FinancialData

	Hits, err := DB.ctl.Query(fmt.Sprintf(sqlGetRange, from, to))
	if err != nil {
		return RangeData, "Query failed"
	}
	defer Hits.Close()

	for Hits.Next() {
		var r, c float64

		Hits.Scan(&r, &c)

		totalRevenue += r
		totalCommission += c
	}

	RangeData.Revenue = totalRevenue
	RangeData.Commission = totalCommission

	return RangeData, ""
}

func (DB *SmartHubDB) GetStatistic(queryFrom, queryTo string) (Statistic, string) {
	var StatisticData Statistic

	if len(queryFrom) < 10 || len(queryTo) < 10 {
		return StatisticData, "Invalid date format"
	}

	if queryRange, msg := DB.GetRangeData(queryFrom, queryTo); msg == "" {
		StatisticData.QueryRange = queryRange
	} else {
		return StatisticData, msg
	}

	if monthRange, msg := DB.GetRangeData(SubMonth(queryFrom), SubMonth(queryTo)); msg == "" {
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

		if monthRange, msg := DB.GetRangeData(monthStart, monthEnd); msg == "" {
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
