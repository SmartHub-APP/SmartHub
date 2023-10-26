﻿package api

import (
	"net/http"
	"encoding/json"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

type LoginRequest struct {
	Account  string `json:"Account"`
	Password string `json:"Password"`
    AccessToken  string `json:"AccessToken"`
	RefreshToken string `json:"RefreshToken"`
}

type LoginReponse struct {
	Username     string `json:"Username"`
	Permission   string `json:"Permission"`
	AccessToken  string `json:"AccessToken"`
	RefreshToken string `json:"RefreshToken"`
}

func RouterLogin(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
			case "POST" :
                var Req LoginRequest

        		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
        		w.Header().Set("Access-Control-Allow-Methods", "POST")

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
                } else {
                    if RET := db.Try2Login(Req.Account, Req.Password); RET.Message == "" {
                        accessTK, refreshTK := SmartHubTool.GetTokens(Req.Account)

                        SmartHubTool.ParseToken(accessTK)
                        SmartHubTool.ParseToken(refreshTK)

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
                }
	    }
	}
}

func DetermineWay(req LoginRequest) (bool, bool, string) {
    if req.AccessToken == "" || req.RefreshToken == "" {
        if req.Account == "" || req.Password == "" {
            return true, false, "Missed field"
        }
    } else {
        atExpire, atUID := SmartHubTool.ParseToken(req.AccessToken)
        rtExpire, rtUID := SmartHubTool.ParseToken(req.RefreshToken)

        if rtExpire {
            return true, false, "Refresh time expired"
        } else {
            if atExpire {
                ret := atUID

                if rtUID != "" { ret = rtUID }

                return false, true, ret
            }
        }
    }

    return false, false, ""
}