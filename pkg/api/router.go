package api

import (
	"net/http"
	SmartHubTool "SmartHub/pkg/tool"
)

func CreateRouter(cfg SmartHubTool.SettingConfig) {
	http.HandleFunc(cfg.API_Base + cfg.API_Login, RouterLogin())

	http.ListenAndServe(":" + cfg.SH_Port, nil)
}