package tool

import (
    "fmt"
    "path/filepath"
    "github.com/akamensky/argparse"
)

func LoadArguments(Args []string) {
    cmd := argparse.NewParser(filepath.Base(Args[0]), "# Start SmartHub by input a json config file")
    cfg := cmd.String("i","config-file",&argparse.Options{
        Required: true,
        Help: "Path to json config file"})
	err := cmd.Parse(Args)

    if err != nil { fmt.Print(cmd.Usage(err)) }

	fmt.Println(*cfg)
}