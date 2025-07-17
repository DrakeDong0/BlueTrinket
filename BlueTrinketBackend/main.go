package main

import (
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/auth"
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/endpoints"
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/db"

	"fmt"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/v2/mongo"
)

var MongoClient *mongo.Client

func main() {
	fmt.Println("Main started")

	// Init JWKS for auth0 authentication
	auth.InitJWKS()

	// Load .env variables
	err := godotenv.Load()
	if err != nil {
		fmt.Println(".env file not found")
	}
	localHost := os.Getenv("PORT")

	// Connect to mongodb
	MongoClient = db.DBConnect()

	// Init router
	router := mux.NewRouter()

	// Define routes
	router.HandleFunc("/test", endpoints.TestEndpoint).Methods("GET")
	router.HandleFunc("/auth/login", endpoints.AuthLogin).Methods("POST")

	// Start and listen on 8010
	err = http.ListenAndServe(":"+localHost, router)
	if err != nil {
		fmt.Println("Server error:", err)
	}
}
