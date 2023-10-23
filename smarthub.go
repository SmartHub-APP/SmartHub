package main

import (
    "log"
    SmartHubAPI "SmartHub/pkg/api"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

var db SmartHubDatabase.SmartHubDB
var cfg SmartHubTool.SettingConfig

func main() {
    log.Println("### SmartHub start")

    log.Println("## 1. Loading argument")
    isOK, msg := cfg.LoadArguments()
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 1. Loading argument", msg)

    log.Println("## 2. Connect to database")
    isOK, msg = db.Connection(cfg)
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 2. Connect to database", msg)

    log.Println("## 3. Check database table")
    isOK, msg = db.CheckTable(cfg)
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 3. Check database table", msg)

    log.Println("## 4. Setup api router")
    SmartHubAPI.CreateRouter(cfg)
    log.Println("## 4. Setup api router done")
}