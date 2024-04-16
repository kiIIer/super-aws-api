package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

// handler is the function that will be called when the server receives a request
func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi")
}
