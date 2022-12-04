package model

type Response struct {
	Type int `json:"type"`
	// ID
	Id int `json:"id"`
	// ユーザー名
	UserName string `json:"user_name"`
	// ユーザーの番号
	Number int `json:"number"`
	// お題
	Theme string `json:"theme"`
	// 発表中の番号
	OtherUsersNumbers []User `json:"other_users_numbers"`
}

func NewResponse() *Response {
	return &Response{
		Type:              0,
		Id:                0,
		UserName:          "",
		Number:            0,
		Theme:             "",
		OtherUsersNumbers: nil,
	}
}