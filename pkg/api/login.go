package api

import (
	"fmt"
	"net/http"
	"encoding/json"
)

func RouterLogin() func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
        r.ParseForm()

		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET")
		w.Header().Set("Content-Type", "application/json")

		switch r.Method {
			case "GET" :
				w.WriteHeader(http.StatusOK)
				fmt.Println(r.URL.Query().Get("s"))

			case "POST" :
				w.WriteHeader(http.StatusCreated)
				json.NewEncoder(w).Encode(map[string]string{"123":"456"})
	    }
	}
}