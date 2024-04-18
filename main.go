package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", handler)

	// Start the HTTPS server in a new goroutine
	go func() {
		defaultCertPath := "env/cert.pem"
		defaultKeyPath := "env/key.pem"

		certPath := os.Getenv("CERT_PATH")
		if certPath == "" {
			certPath = defaultCertPath
		}

		keyPath := os.Getenv("KEY_PATH")
		if keyPath == "" {
			keyPath = defaultKeyPath
		}

		log.Fatal(http.ListenAndServeTLS(":443", certPath, keyPath, nil))
	}()

	// Start the HTTP server
	log.Fatal(http.ListenAndServe(":80", nil))
}

// handler is the function that will be called when the server receives a request
func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "I changed this")
}
