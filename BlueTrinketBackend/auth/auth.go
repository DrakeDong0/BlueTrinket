package auth

import (
	"time"
	"fmt"

	"github.com/MicahParks/keyfunc"
)

var JWKS *keyfunc.JWKS


func InitJWKS() error {
	jwksURL := "https://dev-oxiw8y8jzhq1qfel.us.auth0.com/.well-known/jwks.json"

	var err error
	JWKS, err = keyfunc.Get(jwksURL, keyfunc.Options{
		RefreshInterval: time.Hour,
		RefreshErrorHandler: func(err error) {
			fmt.Printf("JWKS refresh error: %v\n", err)
		},
	})
	return err
}
func GetJWKS() *keyfunc.JWKS {
	return JWKS
}