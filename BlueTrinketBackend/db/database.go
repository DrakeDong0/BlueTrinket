package db

import (
	"context"
	"fmt"
	"os"

	// "time"

	"github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/structs"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/mongo/readpref"
	// "github.com/DrakeDong0/BlueTrinket/BlueTrinketBackend/structs"
)

var MongoClient *mongo.Client

func DBConnect() *mongo.Client {
	// Build and connect URI
	uri := os.Getenv("MONGO_URI")
	serverAPI := options.ServerAPI(options.ServerAPIVersion1)
	opts := options.Client().ApplyURI(uri).SetServerAPIOptions(serverAPI)

	client, err := mongo.Connect(opts)
	if err != nil {
		fmt.Println("Error connecting to MongoDB:", err)
		panic(err)
	}
	// Test connection
	if err := client.Ping(context.TODO(), readpref.Primary()); err != nil {
		panic(err)
	}
	fmt.Println("Pinged your deployment. You successfully connected to MongoDB!")
	return client
}

func GetNextCustomerID(ctx context.Context, db *mongo.Client)(int,error) {
	filter := bson.M{"_id": "customerID"}
	update := bson.M{"$inc": bson.M{"seq": 1}}

	opts := options.FindOneAndUpdate().SetReturnDocument(options.After)
	var result struct {
		Seq int `bson:"seq"`
	}
	customerIDCol := db.Database("BlueTrinket").Collection("Counters")
	err := customerIDCol.FindOneAndUpdate(ctx, filter, update, opts).Decode(&result)
	if err != nil {
		return 0, fmt.Errorf("failed to get next customer ID: %w", err)
	}

	return result.Seq, nil
}

func GetUserBySub(ctx context.Context, client *mongo.Client, sub string) (bson.ObjectID, error) {
	userCol := client.Database("BlueTrinket").Collection("Users")
	filter := bson.M{"sub": sub}
	var result structs.UserLookupDBObj

	err := userCol.FindOne(ctx, filter).Decode(&result)
	if err != nil {
		return bson.NilObjectID, err
	}
	return result.UserID, nil
}
