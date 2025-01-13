package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/gcp-go-batch-sample/batches"
)

type Config struct {
	// Job-defined
	taskNum    string
	attemptNum string

	// User-defined
	sleepMs  int64
	failRate float64
}

func configFromEnv() (Config, error) {
	// Job-defined
	taskNum := os.Getenv("CLOUD_RUN_TASK_INDEX")
	attemptNum := os.Getenv("CLOUD_RUN_TASK_ATTEMPT")
	// User-defined
	sleepMs, err := sleepMsToInt(os.Getenv("SLEEP_MS"))
	failRate, err := failRateToFloat(os.Getenv("FAIL_RATE"))

	if err != nil {
		return Config{}, err
	}

	config := Config{
		taskNum:    taskNum,
		attemptNum: attemptNum,
		sleepMs:    sleepMs,
		failRate:   failRate,
	}
	return config, nil
}

func sleepMsToInt(s string) (int64, error) {
	sleepMs, err := strconv.ParseInt(s, 10, 64)
	return sleepMs, err
}

func failRateToFloat(s string) (float64, error) {
	// Default empty variable to 0
	if s == "" {
		return 0, nil
	}

	// Convert string to float
	failRate, err := strconv.ParseFloat(s, 64)

	// Check that rate is valid
	if failRate < 0 || failRate > 1 {
		return failRate, fmt.Errorf("Invalid FAIL_RATE value: %f. Must be a float between 0 and 1 inclusive.", failRate)
	}

	return failRate, err
}

func main() {
	config, err := configFromEnv()
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("Starting Task #%s, Attempt #%s ...", config.taskNum, config.attemptNum)

	// Arguments
	batchName := flag.String("name", "", "Name of the job")
	fromDate := flag.String("from-date", "", "Start date of the job (ISO 8601 format)")
	toDate := flag.String("to-date", "", "End date of the job (ISO 8601 format)")
	flag.Parse()

	fmt.Printf("Job Name: %s\n", *batchName)
	fmt.Printf("From Date: %s\n", *fromDate)
	fmt.Printf("To Date: %s\n", *toDate)

	args := batches.BatchArgs{
		BatchName: *batchName,
		FromDate:  *fromDate,
		ToDate:    *toDate,
	}

	// ハンドラーのマップ
	handlers := map[string]func(args batches.BatchArgs){
		"sample-success": batches.BatchFail,
		"sample-fail":    batches.BatchFail,
	}

	// 指定されたハンドラーを呼び出し
	if handler, exists := handlers[*batchName]; exists {
		handler(args)
	} else {
		// デフォルトハンドラーを呼び出し
		panic("failed to find batch")
	}

	log.Printf("Completed Task #%s, Attempt #%s", config.taskNum, config.attemptNum)
}
