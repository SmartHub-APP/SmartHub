package api

import (
    "net/http"
	"encoding/json"
    SmartHubDatabase "SmartHub/pkg/database"
)

type TransactoinRequestPost struct {
	Name string `json:"Name"`
	Perm string `json:"Perm"`
}

type TransactoinRequestPut struct {
    ID int `json:"ID"`
	Name string `json:"Name"`
	Perm string `json:"Perm"`
}

func RouterTransactoin(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")

		switch r.Method {
            case "GET":
                if RET, msg := db.TransactoinGET(); msg != "" {
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
                var Req SmartHubDatabase.TransactoinInsert

                err := json.NewDecoder(r.Body).Decode(&Req)
                if err != nil {
                    http.Error(w, "Failed to decode request", http.StatusBadRequest)
                    return
                }

                if ok, after := SmartHubDatabase.ValidTransactoinInsert(Req); ok {
                    Req = after
                } else {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

                if msg := db.TransactoinPOST(Req); msg == "" {
                    w.WriteHeader(http.StatusCreated)
                } else {
                    if err != nil {
                         http.Error(w, msg, http.StatusInternalServerError)
                         return
                     }
                }

			case "PUT":
                var Req SmartHubDatabase.Transactoin

                err := json.NewDecoder(r.Body).Decode(&Req)
                if err != nil {
                    http.Error(w, "Failed to decode request", http.StatusBadRequest)
                    return
                }

                if ok, after := SmartHubDatabase.ValidTransactoin(Req); ok {
                    Req = after
                } else {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

                if msg := db.TransactoinPUT(Req); msg == "" {        
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

                if msg := db.TransactoinDELETE(Req); msg == "" {        
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