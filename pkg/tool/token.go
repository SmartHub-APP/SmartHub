package tool

import (
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

func ParseToken(tokenString string) (jwt.MapClaims, error) {
    token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
        return []byte(jwtKey), nil
    })
    if err != nil {
        return nil, err
    }

    if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
        return claims, nil
    }

    return nil, err
}