package main

import (
    "os"
//    SmartHubAPI "SmartHub/pkg/api"
    SmartHubTool "SmartHub/pkg/tool"
//    SmartHubDatabase "SmartHub/pkg/database"
)

func main() {
    SmartHubTool.LoadArguments(os.Args)
}
