package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	"encoding/json"
	"net/http"
	"strconv"
)

func RouterAppointment(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		switch r.Method {
		case "GET":
			var Req SmartHubDatabase.AppointmentGetRequest

			Req.Name = r.URL.Query().Get("Name")
			Req.ProjectName = r.URL.Query().Get("ProjectName")
			Req.Status, _ = strconv.Atoi(r.URL.Query().Get("Status"))
			Req.AppointTimeStart = r.URL.Query().Get("AppointTimeStart")
			Req.AppointTimeEnd = r.URL.Query().Get("AppointTimeEnd")

			if RET, msg := db.AppointmentGET(Req); msg != "" {
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
			var Req SmartHubDatabase.AppointmentEdit

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if ok, after := SmartHubDatabase.ValidAppointment(Req); ok {
				Req = after
			} else {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.AppointmentPOST(Req); msg == "" {
				w.WriteHeader(http.StatusCreated)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		case "PUT":
			var Req SmartHubDatabase.AppointmentEdit

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if ok, after := SmartHubDatabase.ValidAppointment(Req); ok {
				Req = after
			} else {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.AppointmentPUT(Req); msg == "" {
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

			if msg := db.AppointmentDELETE(Req); msg == "" {
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
