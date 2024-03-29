package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	"encoding/json"
	"net/http"
)

func RouterMember(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		switch r.Method {
		case "OPTIONS":
			w.WriteHeader(http.StatusOK)

			return

		case "GET":
			query := r.URL.Query().Get("q")
			scheme := r.URL.Query().Get("s")

			if query == "" || scheme == "" {
				http.Error(w, "Missing field", http.StatusBadRequest)
				return
			}

			if RET, msg := db.MemberGET(query, scheme); msg != "" {
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
			var Req SmartHubDatabase.Member

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}

			if errorMsg, after := db.ValidMemberInsert(Req); errorMsg == "" {
				Req = after
			} else {
				http.Error(w, errorMsg, http.StatusBadRequest)
				return
			}

			if msg := db.MemberPOST(Req); msg == "" {
				w.WriteHeader(http.StatusCreated)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		case "PUT":
			var Req SmartHubDatabase.Member

			err := json.NewDecoder(r.Body).Decode(&Req)
			if err != nil {
				http.Error(w, "Failed to decode request", http.StatusBadRequest)
				return
			}

			if ok, after := SmartHubDatabase.ValidMember(Req); ok {
				Req = after
			} else {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if msg := db.MemberPUT(Req); msg == "" {
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

			if msg := db.MemberDELETE(Req); msg == "" {
				w.WriteHeader(http.StatusNoContent)
			} else {
				if err != nil {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				}
			}

		default:
		}
	}
}
