package main

import (
    "log"
    SmartHubAPI "SmartHub/pkg/api"
    SmartHubTool "SmartHub/pkg/tool"
    SmartHubDatabase "SmartHub/pkg/database"
)

var SmartHubDB SmartHubDatabase.SmartHubDB
var SmartHubCFG SmartHubTool.SettingConfig

func main() {
    log.Println("### SmartHub start")

    log.Println("## 1. Loading argument")
    isOK, msg := SmartHubCFG.LoadArguments()
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 1. Loading argument", msg)

    log.Println("## 2. Connect to database")
    isOK, msg = SmartHubDB.Connection(SmartHubCFG)
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 2. Connect to database", msg)

    log.Println("## 3. Check database table")
    isOK, msg = SmartHubDB.CheckTable(SmartHubCFG)
    if (!isOK) { log.Fatal("### Error: " + msg + "\n") }
    log.Println("## 3. Check database table", msg)

    log.Println("## 4. Create API router")
    SmartHubAPI.CreateRouter(SmartHubCFG, SmartHubDB)
}