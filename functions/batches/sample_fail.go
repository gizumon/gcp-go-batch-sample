package batches

import (
	"net/http"
)

// HandleFail is an HTTP Cloud Function.
func HandleFail(w http.ResponseWriter, r *http.Request) {
	panic("Dummy Error")
}
