package tool

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

const (
	jwtKey = "JWT-SecurePassword@SmartHub"
)

func GetTokens(username string) (string, string) {
	accessClaims := jwt.MapClaims{
		"UserName": username,
		"ExpireAt": time.Now().Add(time.Hour * 1).Unix(),
	}
	accessJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
	accessToken, _ := accessJWT.SignedString([]byte(jwtKey))

	refreshClaims := jwt.MapClaims{
		"UserName": username,
		"ExpireAt": time.Now().Add(time.Hour * 24).Unix(),
	}
	refreshJWT := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
	refreshToken, _ := refreshJWT.SignedString([]byte(jwtKey))

	return accessToken, refreshToken
}

func ParseToken(tokenString string) (bool, string) {
	Claims := jwt.MapClaims{}

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return []byte(jwtKey), nil
	})

	if err != nil {
		return true, "Failed to parse token"
	}

	Claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return true, "Failed to extract claims"
	}

	expireTime := int64(Claims["ExpireAt"].(float64))

	if time.Now().Unix() > expireTime {
		return true, "Refresh Token has expired"
	}

	return false, Claims["UserName"].(string)
}
