package endpoints

import (
	"fmt"
	"net/http"
)

func TestEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Println("endpoint hit")
	w.Write([]byte("test recieved"))
}
