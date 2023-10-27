package api

import (
    "os"
    "io"
    "fmt"
    "strings"
	"net/http"
    "path/filepath"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

func RouterUpload(db SmartHubDatabase.SmartHubDB, base string) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
        Val := r.URL.Query()

		switch r.Method {
			case "POST" :
                TID := strings.TrimSpace(Val.Get("TID"))

                if TID == "" {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

                r.ParseMultipartForm(500 << 20)

				file, handler, err := r.FormFile("FileContent")
                if err != nil {
                    http.Error(w, "Failed to upload file", http.StatusNotAcceptable)
                    return
                }
                defer file.Close()

                HashCode := SmartHubTool.SHA256EncodeTime(handler.Filename) + filepath.Ext(handler.Filename)

                db.FilePOST(TID, handler.Filename, HashCode)

                dest, err := os.Create(filepath.Join(base, HashCode))
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
        		w.Header().Set("Access-Control-Allow-Methods", "POST, DELETE")
                w.WriteHeader(http.StatusCreated)

            case "DELETE" :
                var Req string

                file := strings.TrimSpace(Val.Get("file"))

                if file == "" {
                    http.Error(w, "Missed field", http.StatusBadRequest)
                    return
                }

                fmt.Println(filepath.Join(base, Req))

                err := os.Remove(filepath.Join(base, Req))
                if err != nil {
                    http.Error(w, "Failed to delete file", http.StatusInternalServerError)
                    return
                }

                if msg := db.FileDELETE(Req); msg == "" {
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