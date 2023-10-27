package api

import (
//	"fmt"
    "strings"
    "net/http"
	"encoding/json"
    SmartHubDatabase "SmartHub/pkg/database"
)

type RoleRequest struct {
	Name string `json:"Name"`
	Perm string `json:"Perm"`
}

func RouterRole(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")

		switch r.Method {
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
        
                    w.Header().Set("Content-Type", "application/json")
                    w.WriteHeader(http.StatusOK)
                    w.Write(jsonResponse)
                }

			case "POST" :
                var Req RoleRequest

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

                if msg := db.RolePOST(Req.Name, Req.Perm); msg == "" {        
                    w.WriteHeader(http.StatusOK)
                } else {
                    if err != nil {
                         http.Error(w, msg, http.StatusInternalServerError)
                         return
                     }
                }
	    }
	}
}