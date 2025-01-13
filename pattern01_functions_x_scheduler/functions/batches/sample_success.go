package batches

import (
	"fmt"
	"net/http"
)

// HandleSuccess is an HTTP Cloud Function.
func HandleSuccess(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello, World!")
}
