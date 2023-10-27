package tool

import (
	"os"
)

func EnsureFolder(path string) error {
	return os.MkdirAll(path, os.ModePerm)
}