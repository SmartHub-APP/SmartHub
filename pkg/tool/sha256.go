package tool

import (
	"crypto/sha256"
	"encoding/hex"
	"time"
)

func SHA256EncodeTime(input string) string {
	hasher := sha256.New()
	hasher.Write([]byte(input + time.Now().Format("2006-01-02 15:04:05")))

	return hex.EncodeToString(hasher.Sum(nil))
}
