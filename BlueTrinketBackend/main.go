package main

import (
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/endpoints"
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/mongodb"

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

	err := godotenv.Load()
	if err != nil {
		fmt.Println(".env file not found")
	}
	localHost := os.Getenv("PORT")

	MongoClient = mongodb.DBConnect()

	// Init router
	router := mux.NewRouter()

	// Define routes
	router.HandleFunc("/test", endpoints.TestEndpoint).Methods("GET")

	// Start and listen on 8010
	err = http.ListenAndServe(":"+localHost, router)
	if err != nil {
		fmt.Println("Server error:", err)
	}
}
