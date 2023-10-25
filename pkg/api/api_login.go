package api

import (
	"net/http"
	"encoding/json"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

type User struct {
	Username string `json:"Username"`
	Password string `json:"Password"`
}

func RouterLogin(db SmartHubDatabase.SmartHubDB) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
        r.ParseForm()

        var u User

		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET")
		w.Header().Set("Content-Type", "application/json")

        err := json.NewDecoder(r.Body).Decode(&u)
        if err != nil {
            http.Error(w, "Failed to decode response", http.StatusBadRequest)
            return
        }

		switch r.Method {
			case "POST" :
                if u.Username == "" || u.Password == "" {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

				if ok, msg := db.Try2Login(u.Username, u.Password); ok {
                    accessToken, refreshToken := SmartHubTool.GetTokens(u.Username)
            
                    response := map[string]string{
                        "access_token":  accessToken,
                        "refresh_token": refreshToken,
                    }
            
                    jsonResponse, err := json.Marshal(response)
                    if err != nil {
                        http.Error(w, err.Error(), http.StatusInternalServerError)
                        return
                    }
            
                    w.WriteHeader(http.StatusOK)
                    w.Write(jsonResponse)
                } else {
                    http.Error(w, msg, http.StatusUnauthorized)
                }
	    }
	}
}