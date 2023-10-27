package api

import (
	"fmt"
	"net/http"
	SmartHubTool "SmartHub/pkg/tool"
	SmartHubDatabase "SmartHub/pkg/database"
)

func CreateRouter(cfg SmartHubTool.SettingConfig, db SmartHubDatabase.SmartHubDB) {
	fmt.Println(cfg.API_CDN, cfg.SH_CDN)
    http.Handle(cfg.API_CDN, http.StripPrefix(cfg.API_CDN, http.FileServer(http.Dir(cfg.SH_CDN))))
	http.HandleFunc(cfg.API_Base + cfg.API_Login, RouterLogin(db))
	http.HandleFunc(cfg.API_Base + cfg.API_Role, RouterRole(db))
	http.HandleFunc(cfg.API_Base + cfg.API_Member, RouterMember(db))
	http.ListenAndServe(":" + cfg.SH_Port, nil)
}