package tool

import (
    "os"
    "io/ioutil"
    "encoding/json"
    "path/filepath"
    "github.com/akamensky/argparse"
)

type SettingConfig struct {
    SH_Port         string  `json:"SH_Port"`
    SH_CDN          string  `json:"SH_CDN"`
    DB_Name         string  `json:"DB_Name"`
    DB_User         string  `json:"DB_User"`
    DB_Password     string  `json:"DB_Password"`
    DB_Address      string  `json:"DB_Address"`
    DB_Port         string  `json:"DB_Port"`
    TB_User         string  `json:"TB_User"`
    TB_Role         string  `json:"TB_Role"`
    TB_Transaction  string  `json:"TB_Transaction"`
    TB_Appointment  string  `json:"TB_Appointment"`
    API_Base        string  `json:"API_Base"`
    API_CDN         string  `json:"API_CDN"`
    API_Login       string  `json:"API_Login"`
    API_Role        string  `json:"API_Role"`
    API_Member      string  `json:"API_Member"`
    API_Transaction string  `json:"API_Transaction"`
    API_Appointment string  `json:"API_Appointment"`
}

func (config *SettingConfig) LoadArguments() (bool, string) {
    cmd := argparse.NewParser(filepath.Base(os.Args[0]), "# Start SmartHub by input a json config file")
    cfg := cmd.String("i", "config-file", &argparse.Options{
        Required: true,
        Help: "Path to json config file"})
	err := cmd.Parse(os.Args)

    if err != nil { return false, cmd.Usage(err) }

    if _, err := os.Stat(*cfg);  err != nil { return false, "File not exists" }

    jsonConfig, err := os.Open(*cfg)
    if err != nil { return false, "Cannot open json file" }
    defer jsonConfig.Close()

    FileBytes, _ := ioutil.ReadAll(jsonConfig)

    json.Unmarshal(FileBytes, &config)

    return true, "success"
}