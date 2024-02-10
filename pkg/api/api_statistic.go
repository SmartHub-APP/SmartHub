package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	"encoding/json"
	"net/http"
)

func RouterStatistic(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		switch r.Method {
		case "OPTIONS":
			w.WriteHeader(http.StatusOK)

			return

		case "GET":
			DateStart := r.URL.Query().Get("DateStart")
			DateEnd := r.URL.Query().Get("DateEnd")

			if DateStart == "" || DateEnd == "" {
				http.Error(w, "DateStart and DateEnd are required", http.StatusBadRequest)
				return
			}

			if RET, msg := db.GetStatistic(DateStart, DateEnd); msg != "" {
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

		default:
			http.Error(w, "No such method", http.StatusMethodNotAllowed)
		}
	}
}
