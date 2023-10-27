package api

import (
    "os"
    "io"
	"net/http"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

func RouterUpload(db SmartHubDatabase.SmartHubDB, base string) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
			case "POST" :
                r.ParseMultipartForm(300 << 20)

				file, handler, err := r.FormFile("FileContent")
                if err != nil {
                    http.Error(w, "Failed to upload file", http.StatusNotAcceptable)
                    return
                }
                defer file.Close()

                dest, err := os.Create(SmartHubTool.SHA256FilePath(base, handler.Filename))
                if err != nil {
                    http.Error(w, "Failed to create file", http.StatusInternalServerError)
                    return
                }
                defer dest.Close()

                if _, err := io.Copy(dest, file); err != nil {
                    http.Error(w, "Copy data error", http.StatusInternalServerError)
                    return
                }

        		w.Header().Set("Access-Control-Allow-Origin", r.Header.Get("Origin"))
        		w.Header().Set("Access-Control-Allow-Methods", "POST")
                w.WriteHeader(http.StatusCreated)

            default:
                http.Error(w, "No such method", http.StatusMethodNotAllowed)
	    }
	}
}