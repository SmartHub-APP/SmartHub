package tool

import (
    "fmt"
    "time"
	"github.com/dgrijalva/jwt-go"
)

const (
    jwtKey = "JWT-SecurePassword@SmartHub"
)

func GetTokens(username string) (string, string) {
    accessClaims := jwt.MapClaims{
        "username": username,
        "exp": time.Now().Add(time.Hour * 1).Unix(),
    }
    accessJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
    accessToken, _ := accessJWT.SignedString([]byte(jwtKey))

    refreshClaims := jwt.MapClaims{
        "username": username,
        "exp":      time.Now().Add(time.Hour * 24).Unix(),
    }
    refreshJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
    refreshToken, _ := refreshJWT.SignedString([]byte(jwtKey))

    return accessToken, refreshToken
}

func ParseToken(tokenString string) (string, error) {
    claims := jwt.MapClaims{}

    token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
        return []byte(jwtKey), nil
    })

    if err != nil { return "Failed to parse token", err }
    
    claims, ok := token.Claims.(jwt.MapClaims)
	if !ok { return "Failed to extract claims", err }

    fmt.Println("=========================")
    for key, val := range claims {
        fmt.Printf("Key: %v, value: %v\n", key, val)
    }
    fmt.Println("=========================")

    return "", nil
}