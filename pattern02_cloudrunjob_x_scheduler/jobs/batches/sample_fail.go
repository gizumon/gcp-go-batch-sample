package batches

type BatchArgs struct {
	BatchName string
	FromDate  string
	ToDate    string
}

func BatchFail(args BatchArgs) {
	panic("Dummy Error")
}
