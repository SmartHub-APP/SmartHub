package api

import (
//	"fmt"
    "net/http"
	"encoding/json"
    SmartHubDatabase "SmartHub/pkg/database"
)

type RoleRequest struct {
	Account  string `json:"Account"`
	Password string `json:"Password"`
}

func RouterRole(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")

		switch r.Method {
            case "GET":
                if RET, msg := db.GetRoles(); msg != "" {
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
/*
			case "POST" :
                var Req LoginRequest

                err := json.NewDecoder(r.Body).Decode(&Req)
                if err != nil {
                    http.Error(w, "Failed to decode request", http.StatusBadRequest)
                    return
                }

                isFailed, goRefresh, msg := DetermineWay(Req)
                if isFailed {
                    http.Error(w, msg, http.StatusBadRequest)
                    return
                }

                var Resp LoginReponse

                if goRefresh {
                    accessTK, refreshTK := SmartHubTool.GetTokens(Req.Account)
                    rf := db.GetNameAndPerm(Req.Account)

                    Resp.Username, Resp.Permission = rf.Username, rf.Permission
                    Resp.AccessToken, Resp.RefreshToken = accessTK, refreshTK

                    jsonResponse, err := json.Marshal(Resp)
                    if err != nil {
                        http.Error(w, err.Error(), http.StatusInternalServerError)
                        return
                    }
        
                    w.Header().Set("Content-Type", "application/json")
                    w.WriteHeader(http.StatusOK)
                    w.Write(jsonResponse)
                } else {
                    if RET := db.Try2Login(Req.Account, Req.Password); RET.Message == "" {
                        accessTK, refreshTK := SmartHubTool.GetTokens(Req.Account)

                        Resp.Username, Resp.Permission = RET.Username, RET.Permission
                        Resp.AccessToken, Resp.RefreshToken = accessTK, refreshTK

                        jsonResponse, err := json.Marshal(Resp)
                        if err != nil {
                            http.Error(w, err.Error(), http.StatusInternalServerError)
                            return
                        }
            
                        w.Header().Set("Content-Type", "application/json")
                        w.WriteHeader(http.StatusOK)
                        w.Write(jsonResponse)
                    } else {
                        http.Error(w, RET.Message, http.StatusUnauthorized)
                    }
                }*/
	    }
	}
}