package api

import (
	"net/http"
	SmartHubTool "SmartHub/pkg/tool"
	SmartHubDatabase "SmartHub/pkg/database"
)

func CreateRouter(cfg SmartHubTool.SettingConfig, db SmartHubDatabase.SmartHubDB) {
    http.Handle(cfg.API_CDN, http.StripPrefix(cfg.API_CDN, http.FileServer(http.Dir(cfg.SH_CDN))))
	http.HandleFunc(cfg.API_Base + cfg.API_File, RouterFile(db, cfg.SH_CDN))
	http.HandleFunc(cfg.API_Base + cfg.API_Login, RouterLogin(db))
	http.HandleFunc(cfg.API_Base + cfg.API_Role, RouterRole(db))
	http.HandleFunc(cfg.API_Base + cfg.API_Member, RouterMember(db))
	http.HandleFunc(cfg.API_Base + cfg.API_Transaction, RouterTransactoin(db))
//	http.HandleFunc(cfg.API_Base + cfg.API_Appointment, RouterAppointment(db))
	http.ListenAndServe(":" + cfg.SH_Port, nil)
}