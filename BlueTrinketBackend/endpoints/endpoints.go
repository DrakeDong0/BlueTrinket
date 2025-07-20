package endpoints

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"

	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/db"
	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/structs"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
)

var MongoClient *mongo.Client

func TestEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Println("endpoint hit")
	w.Write([]byte("test recieved"))
}

func AuthLogin(w http.ResponseWriter, r *http.Request) {
	fmt.Println("auth login hit")
	ctx := r.Context()

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

	// Check for new user
	userID, err := db.GetUserBySub(ctx, MongoClient, userInfo.Sub)
	if err != nil {
		fmt.Println("error: ", err)
		fmt.Printf("raw err: %v, type: %T\n", err, err)
		if err == mongo.ErrNoDocuments {
			err = createUser(ctx, MongoClient, userInfo)
			if err != nil {
				http.Error(w, "Failed to create user", http.StatusInternalServerError)
				return
			}
			w.Write([]byte(`{"isNewUser": true}`))
		} else {
			fmt.Println("error retrieving user", err)
		}
	} else {
		fmt.Println("user exists with id: ", userID)
		w.Write([]byte(`{"isNewUser": false}`))
	}
}

func createUser(ctx context.Context, client *mongo.Client, newUser structs.UserDBObj) error {
	// Get ID for new user
	newUserID, err := db.GetNextCustomerID(ctx, client)
	if err != nil {
		return fmt.Errorf("Error:%w", err)
	}
	fmt.Println("new user id: ", newUserID)
	// Create new database for user
	userInfoCol := client.Database(strconv.Itoa(newUserID)).Collection("userInfo")
	res, err := userInfoCol.InsertOne(ctx, newUser)
	if err != nil {
		return fmt.Errorf("error creating new user database:%w", err)
	}
	// Add user lookup to BlueTrinket user list for lookup
	id, ok := res.InsertedID.(bson.ObjectID)
	if !ok {
		return fmt.Errorf("inserted ID is not an objectID")
	}
	lookupData := []structs.UserLookupDBObj{
		{
			UserID: id,
			Email:  newUser.Email,
		},
		{
			UserID: id,
			Sub:    newUser.Sub,
		},
	}
	userLookupCol := client.Database("BlueTrinket").Collection("Users")
	_, err = userLookupCol.InsertMany(ctx, lookupData)
	if err != nil {
		return fmt.Errorf("error creating user lookup in BlueTrinket DB:%w", err)
	}
	fmt.Println("created new user successfully")
	return nil
}
