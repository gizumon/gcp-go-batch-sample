package function

import (
	"gcp-go-batch-sample/batches"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

func init() {
	functions.HTTP("success", batches.HandleSuccess)
	functions.HTTP("fail", batches.HandleFail)
}
