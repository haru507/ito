package model

type Request struct {
	// タイプ 0:お題 1:数字発表 2:ユーザー名
	Type     int    `json:"type"`
	// ユーザーID
	UserID   int    `json:"user_id"`
	// ユーザー名
	UserName string `json:"user_name"`
	// 番号
	Number   int    `json:"number"`
	//
	Odai     string `json:"odai"`
}