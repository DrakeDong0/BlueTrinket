package endpoints

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/db"
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/structs"
	"go.mongodb.org/mongo-driver/v2/mongo"
)

var MongoClient *mongo.Client

func TestEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Println("endpoint hit")
	w.Write([]byte("test recieved"))
}

func AuthLogin(w http.ResponseWriter, r *http.Request) {
	fmt.Println("auth login hit")

	authHeader := r.Header.Get("Authorization")
	parts := strings.SplitN(authHeader, " ", 2)
	if len(parts) != 2 || parts[0] != "Bearer" {
		http.Error(w, "Invalid Authorization header", http.StatusUnauthorized)
		return
	}
	accessToken := parts[1]

	// Call Auth0 /userinfo endpoint
	userinfoURL := os.Getenv("AUTH0_DOMAIN") + "userinfo"
	req, err := http.NewRequest("GET", userinfoURL, nil)
	if err != nil {
		http.Error(w, "Failed to create request", http.StatusInternalServerError)
		return
	}

	req.Header.Set("Authorization", "Bearer "+accessToken)

	res, err := http.DefaultClient.Do(req)
	if err != nil || res.StatusCode != http.StatusOK {
		fmt.Println("Failed to get user info", err)
		return
	}

	defer res.Body.Close()

	var userInfo structs.UserDBObj

	if err := json.NewDecoder(res.Body).Decode(&userInfo); err != nil {
		http.Error(w, "Failed to parse user info", http.StatusInternalServerError)
		return
	}

	fmt.Println("user info: ", userInfo)

	MongoClient = db.DBConnect()

	// Check for new user
	_, err = db.GetUserBySub(MongoClient, userInfo.Sub)
	if err != nil {
		if err == mongo.ErrNoDocuments{
			createUser(MongoClient, userInfo.Sub)
			w.Write([]byte(`{"isNewUser": true}`))
		} else{
			fmt.Println("error retrieving user")
		}
	} else {
		w.Write([]byte(`{"isNewUser": false}`))
	}
}

func createUser(client *mongo.Client, sub string){

}