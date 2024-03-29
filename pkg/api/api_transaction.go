package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	"encoding/json"
	"net/http"
	"strconv"
)

func RouterTransaction(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		switch r.Method {
		case "OPTIONS":
			w.WriteHeader(http.StatusOK)

			return

		case "GET":
			var Req SmartHubDatabase.TransactionGetRequest

			Req.Name = r.URL.Query().Get("Name")
			Req.ProjectName = r.URL.Query().Get("ProjectName")
			Req.Status, _ = strconv.Atoi(r.URL.Query().Get("Status"))
			Req.PayStatus, _ = strconv.Atoi(r.URL.Query().Get("PayStatus"))
			Req.Unit = r.URL.Query().Get("Unit")
			Req.LaunchDateStart = r.URL.Query().Get("LaunchDateStart")
			Req.LaunchDateEnd = r.URL.Query().Get("LaunchDateEnd")
			Req.SaleDateStart = r.URL.Query().Get("SaleDateStart")
			Req.SaleDateEnd = r.URL.Query().Get("SaleDateEnd")

			if RET, msg := db.TransactionGET(Req); msg != "" {
				http.Error(w, msg, http.StatusInternalServerError)
				return
			} else {
				jsonResponse, err := json.Marshal(RET)
				if err != nil {
					http.Error(w, err.Error(), http.StatusInternalServerError)
					return
				}

				w.Header().Set("Content-Type", "application/json; charset=utf-8")
				w.WriteHeader(http.StatusOK)
				w.Write(jsonResponse)
			}

		case "POST":
			var Req SmartHubDatabase.TransactionPost

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if Req.Status <= 0 && Req.PayStatus <= 0 {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.TransactionPOST(Req); msg == "" {
				w.WriteHeader(http.StatusCreated)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		case "PUT":
			var Req SmartHubDatabase.TransactionPut

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if Req.Status <= 0 && Req.PayStatus <= 0 {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.TransactionPUT(Req); msg == "" {
				w.WriteHeader(http.StatusNoContent)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		case "DELETE":
			var Req []int

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if msg := db.TransactionDELETE(Req); msg == "" {
				w.WriteHeader(http.StatusNoContent)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		default:
			http.Error(w, "No such method", http.StatusMethodNotAllowed)
		}
	}
}
