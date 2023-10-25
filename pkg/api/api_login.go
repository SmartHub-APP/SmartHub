package api

import (
	"net/http"
	"encoding/json"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

type LoginRequest struct {
	Account  string `json:"Account"`
	Password string `json:"Password"`
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
                    http.Error(w, "Failed to decode response", http.StatusBadRequest)
                    return
                }

                if Req.Account == "" || Req.Password == "" {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

				if RET := db.Try2Login(Req.Account, Req.Password); RET.Message == "" {
                    var Resp LoginReponse

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
	    }
	}
}