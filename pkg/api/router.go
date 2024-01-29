package api

import (
	SmartHubDatabase "SmartHub/pkg/database"
	SmartHubTool "SmartHub/pkg/tool"
	"net/http"
)

func CreateRouter(cfg SmartHubTool.SettingConfig, db SmartHubDatabase.SmartHubDB) {
	http.HandleFunc(cfg.API_Base+cfg.API_File, RouterFile(db, cfg.SH_CDN))
	http.HandleFunc(cfg.API_Base+cfg.API_Login, RouterLogin(db))
	http.HandleFunc(cfg.API_Base+cfg.API_Role, RouterRole(db))
	http.HandleFunc(cfg.API_Base+cfg.API_Member, RouterMember(db))
	http.HandleFunc(cfg.API_Base+cfg.API_Transaction, RouterTransaction(db))
	//	http.HandleFunc(cfg.API_Base + cfg.API_Appointment, RouterAppointment(db))
	http.ListenAndServe(":"+cfg.SH_Port, nil)
}
