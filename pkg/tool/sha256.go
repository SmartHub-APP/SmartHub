package tool

import (
    "fmt"
    "time"
    "path/filepath"
    "crypto/sha256"
)

func SHA256EncodeTime(input string) string {
    hasher := sha256.New()
    hasher.Write([]byte(input + time.Now().Format("2006-01-02 15:04:05")))

    return fmt.Sprintf("%x", hasher.Sum(nil))
}

func SHA256FilePath(base, input string) string {
    fName := SHA256EncodeTime(input) + filepath.Ext(input)

    return filepath.Join(base, fName)
}