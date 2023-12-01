package api

import (
    "fmt"
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
        w.Header().Set("Access-Control-Allow-Origin", "*")
    	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
    	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		switch r.Method {
            case "OPTIONS":
    			w.WriteHeader(http.StatusOK)

    			return

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
        
                    w.Header().Set("Content-Type", "application/json; charset=utf-8")
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
            
                        w.Header().Set("Content-Type", "application/json; charset=utf-8")
                        w.WriteHeader(http.StatusOK)
                        w.Write(jsonResponse)
                    } else {
                        http.Error(w, RET.Message, http.StatusUnauthorized)
                    }
                }

            default:
                http.Error(w, "No such method", http.StatusMethodNotAllowed)
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

        fmt.Println("AccessToken ", atExpire, atUID)
        fmt.Println("RefreshToken", atExpire, atUID)

        if rtExpire {
            return true, false, "Refresh time expired"
        } else {
            if atExpire {
                return false, true, rtUID
            } else {
                return false, true, atUID
            }
        }
    }

    return false, false, ""
}