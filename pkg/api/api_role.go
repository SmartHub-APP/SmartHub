package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	"encoding/json"
	"net/http"
	"strings"
)

type RoleRequestPost struct {
	Name string `json:"Name"`
	Perm string `json:"Perm"`
}

type RoleRequestPut struct {
	ID   int    `json:"ID"`
	Name string `json:"Name"`
	Perm string `json:"Perm"`
}

func RouterRole(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")

		switch r.Method {
		case "OPTIONS":
			w.WriteHeader(http.StatusOK)

			return

		case "GET":
			if RET, msg := db.RoleGET(); msg != "" {
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
			var Req RoleRequestPost

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			trimName := strings.TrimSpace(Req.Name)
			trimPerm := strings.TrimSpace(Req.Perm)

			if trimName == "" || trimPerm == "" {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.RolePOST(trimName, trimPerm); msg == "" {
				w.WriteHeader(http.StatusCreated)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		case "PUT":
			var Req RoleRequestPut

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			trimName := strings.TrimSpace(Req.Name)
			trimPerm := strings.TrimSpace(Req.Perm)

			if trimName == "" || trimPerm == "" || Req.ID == 0 {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.RolePUT(trimName, trimPerm, Req.ID); msg == "" {
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

			if msg := db.RoleDELETE(Req); msg == "" {
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
