package main

import (
	SmartHubAPI "SmartHub/pkg/api"
	SmartHubDatabase "SmartHub/pkg/database"
	SmartHubTool "SmartHub/pkg/tool"
	"log"
	"os"
)

var SmartHubDB SmartHubDatabase.SmartHubDB
var SmartHubCFG SmartHubTool.SettingConfig

func main() {
	log.Println("### SmartHub start")

	log.Println("## 1. Loading argument")
	isOK, msg := SmartHubCFG.LoadArguments()
	if !isOK {
		log.Fatal("### Error: " + msg + "\n")
	}
	log.Println("## 1. Loading argument", msg)

	log.Println("## 2. Connect to database")
	isOK, msg = SmartHubDB.Connection(SmartHubCFG)
	if !isOK {
		log.Fatal("### Error: " + msg + "\n")
	}
	log.Println("## 2. Connect to database", msg)

	log.Println("## 3. Check database table")
	isOK, msg = SmartHubDB.CheckTable(SmartHubCFG)
	if !isOK {
		log.Fatal("### Error: " + msg + "\n")
	}
	log.Println("## 3. Check database table", msg)

	log.Println("## 4. Setup cdn folder")
	err := os.MkdirAll(SmartHubCFG.SH_CDN, os.ModePerm)
	if err != nil {
		log.Fatal("### Error: Create CDN archive error\n")
	}
	log.Println("## 4. Setup cdn folder success")

	log.Println("## 5. Create API router")
	SmartHubAPI.CreateRouter(SmartHubCFG, SmartHubDB)
}
