﻿package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	SmartHubTool "SmartHub/pkg/tool"
	"encoding/json"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func RouterFile(db SmartHubDatabase.SmartHubDB, base string) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		Val := r.URL.Query()

		switch r.Method {
		case "OPTIONS":
			w.WriteHeader(http.StatusOK)

			return

		case "GET":
			TID := strings.TrimSpace(Val.Get("TID"))

			if TID == "" {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			if FID := strings.TrimSpace(Val.Get("FID")); FID == "" {
				if Files, msg := db.FileGET(TID); msg != "" {
					http.Error(w, msg, http.StatusInternalServerError)
					return
				} else {
					jsonResponse, err := json.Marshal(Files)
					if err != nil {
						http.Error(w, err.Error(), http.StatusInternalServerError)
						return
					}

					w.Header().Set("Content-Type", "application/json; charset=utf-8")
					w.WriteHeader(http.StatusOK)
					w.Write(jsonResponse)
				}
			} else {
				fPath := filepath.Join(base, FID)

				if _, err := os.Stat(fPath); err == nil {
					if Files, msg := db.FileGET(TID); msg != "" {
						http.Error(w, msg, http.StatusInternalServerError)
						return
					} else {
						fName := ""

						for _, File := range Files {
							if File.HashCode == FID {
								fName = File.FileName
								break
							}
						}

						if fName == "" {
							w.Header().Set("Content-Disposition", "attachment; filename="+FID)
						} else {
							w.Header().Set("Content-Disposition", "attachment; filename="+fName)
						}

						http.ServeFile(w, r, fPath)
					}
				} else {
					http.Error(w, err.Error(), http.StatusNotFound)
					return
				}
			}

		case "POST":
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

		case "DELETE":
			file := strings.TrimSpace(Val.Get("file"))

			if file == "" {
				http.Error(w, "Missed field", http.StatusBadRequest)
				return
			}

			err := os.Remove(filepath.Join(base, file))
			if err != nil {
				http.Error(w, "Failed to delete file", http.StatusInternalServerError)
				return
			}

			if msg := db.FileDELETE(file); msg == "" {
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
