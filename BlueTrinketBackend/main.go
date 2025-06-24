package main

import (
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/endpoints"

	"fmt"
	"net/http"
	"github.com/gorilla/mux"
)

func main() {
	fmt.Println("Main started")
	router := mux.NewRouter()

	router.HandleFunc("/test", endpoints.TestEndpoint).Methods("GET")

	err := http.ListenAndServe(":8010", router)
	if err != nil {
		fmt.Println("Server error:", err)
	}
}
