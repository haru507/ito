package model

// Game ゲーム全体の構造体
type Game struct {
	// お題
	Theme string `json:"theme"`
	// 出題中の番号
	OtherUsersNumbers []User `json:"other_users_numbers"`
}
