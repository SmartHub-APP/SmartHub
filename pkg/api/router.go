package api

import (
	"net/http"
	SmartHubTool "SmartHub/pkg/tool"
	SmartHubDatabase "SmartHub/pkg/database"
)

func CreateRouter(cfg SmartHubTool.SettingConfig, db SmartHubDatabase.SmartHubDB) {
	http.HandleFunc(cfg.API_Base + cfg.API_Login, RouterLogin(db))

	http.ListenAndServe(":" + cfg.SH_Port, nil)
}