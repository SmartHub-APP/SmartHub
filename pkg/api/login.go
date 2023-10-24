package api

import (
    "fmt"
    "time"
	"net/http"
	"encoding/json"
	"github.com/dgrijalva/jwt-go"
)

type User struct {
	Username string `json:"Username"`
	Password string `json:"Password"`
}

const (
    jwtKey = "JWT-SecurePassword@SmartHub"
)

func RouterLogin() func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
        r.ParseForm()

        var u User

		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET")
		w.Header().Set("Content-Type", "application/json")

        fmt.Println(r.Body)
        err := json.NewDecoder(r.Body).Decode(&u)
        if err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }

		switch r.Method {
			case "POST" :
                fmt.Println(u.Username, u.Password)

				if success := true /*Try2Login(u.Username, u.Password)*/; success {
                    accessToken, refreshToken := getTokens(u.Username)
            
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
                    http.Error(w, "Unauthorized", http.StatusUnauthorized)
                }
	    }
	}
}

func getTokens(username string) (string, string) {
    accessClaims := jwt.MapClaims{
        "username": username,
        "exp": time.Now().Add(time.Hour * 1).Unix(),
    }
    accessJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
    accessToken, _ := accessJWT.SignedString([]byte(jwtKey))

    refreshClaims := jwt.MapClaims{
        "username": username,
        "exp":      time.Now().Add(time.Hour * 24).Unix(),
    }
    refreshJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
    refreshToken, _ := refreshJWT.SignedString([]byte(jwtKey))

    return accessToken, refreshToken
}