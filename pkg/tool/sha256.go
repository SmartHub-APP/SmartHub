package tool

import (
    "fmt"
    "time"
    "encoding/hex"
    "path/filepath"
    "crypto/sha256"
)

func SHA256EncodeTime(input string) string {
    hasher := sha256.New()
    hasher.Write([]byte(input + time.Now().Format("2006-01-02 15:04:05")))

    return hex.EncodeToString(hasher.Sum(nil))
}

func SHA256FilePath(base, input string) string {
    fmt.Println(filepath.Join(base, SHA256EncodeTime(input) + filepath.Ext(input)))
    return filepath.Join(base, SHA256EncodeTime(input) + filepath.Ext(input))
}