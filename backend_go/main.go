package main

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"golang.org/x/net/websocket"
	"io"
	"job_go/model"
	"job_go/service"
	"net/http"
	"strconv"
	"sync"
)

// ユーザー情報（グローバル）
var Users []model.User

// ゲーム情報
var Game model.Game

// IDのシーケンス
var IdSeq = 0

var connectionPool = struct {
	sync.RWMutex
	connections map[*websocket.Conn]struct{}
}{
	connections: make(map[*websocket.Conn]struct{}),
}

func init() {
	// 空配列をセットする
	Users = []model.User{}
	Game = model.Game{
		Theme:             "",
		OtherUsersNumbers: []model.User{},
	}
	IdSeq = 0
}

// handleWebSocket はWebSocketの処理を行う
func handleWebSocket(c echo.Context) error {
	errorHandler := make(chan error)
	websocket.Handler(func(ws *websocket.Conn) {
		// コネクションクローズ削除(エラー発生後処理)
		defer func(connection *websocket.Conn) {
			if err := ws.Close(); err != nil {
				errorHandler <- err
			}
		}(ws)

		connectionPool.Lock()
		connectionPool.connections[ws] = struct{}{}
		// コネクション削除(エラー発生後処理)
		defer func(connection *websocket.Conn) {
			fmt.Println(fmt.Sprintf("コネクション削除"))
			connectionPool.Lock()
			delete(connectionPool.connections, connection)
			connectionPool.Unlock()
		}(ws)

		connectionPool.Unlock()

		// Client からデータを読み込み
		var request = model.Request{
			Type:     0,
			UserID:   0,
			UserName: "",
			Number:   0,
			Odai:     "",
		}

		for {
			// requestにデータを設定
			err := websocket.JSON.Receive(ws, &request)
			if err != nil {
				fmt.Println("エラー発生")
				c.Logger().Error(err)
				if err != io.EOF {
					removeUser(request.UserID)
					break
				} else {
					fmt.Println("通信切断")
					fmt.Println(fmt.Sprintf(
						"削除するユーザー情報:リクエストタイプ:%v ユーザーID: %v, ユーザー名: %s, お題:%s, 発表番号:%v",
						request.Type, request.UserID, request.UserName, request.Odai, request.Number,
					))
					removeUser(request.UserID)
					break
				}
			}
			fmt.Println(fmt.Sprintf("リクエスト確認:リクエストタイプ:%v ユーザーID: %v, ユーザー名: %s, お題:%s, 発表番号:%v", request.Type, request.UserID, request.UserName, request.Odai, request.Number))

			response := model.NewResponse()
			// 取得したTypeごとに処理
			switch request.Type {
			case model.TypeTheme:
				// テーマを取得する
				Game.Theme = request.Odai
				// お題をResponseで返却
				response.Theme = request.Odai
				// typeをセット
				response.Type = model.TypeTheme
			case model.TypeNumber:
				// ユーザーの情報を更新する
				for index, user := range Users {
					//if request.UserID == 0 {
					//	// リクエストのUserIDが0の場合はユーザー名から検索する
					//	if user.UserName == request.UserName {
					//		// idの再番
					//		Users[index].Id = IdSeq
					//		// 番号の更新
					//		Users[index].Number = request.Number
					//		Game.OtherUsersNumbers = append(Game.OtherUsersNumbers, Users[index])
					//		// IDを更新
					//		IdSeq++
					//	}
					//}
					// ユーザーIDが一致する
					if user.Id == request.UserID {
						// 番号の更新
						// 自身の番号はフロント側にしか保持していないので、サーバー側のユーザー情報に自分の番号をセットする。
						Users[index].Number = request.Number
						// 選択済みユーザーとして追加
						Game.OtherUsersNumbers = append(Game.OtherUsersNumbers, Users[index])
					}
				}
				// responseの作成
				response.Type = model.TypeNumber
				response.Number = request.Number
				response.Id = request.UserID
				response.OtherUsersNumbers = Game.OtherUsersNumbers
			case model.TypeUser:
				// ユーザー新規作成
				user := model.NewUser(request.UserID, request.UserName)
				// 番号再番
				user.Number = service.RandNumber()
				fmt.Println(user.Number)
				// ユーザー追加
				Users = append(Users, *user)
				// レスポンス作成
				response.Type = model.TypeUser
				response.UserName = request.UserName
				response.Id = request.UserID
				response.Number = user.Number
				if Game.Theme != "" {
					response.Theme = Game.Theme
				}
				response.OtherUsersNumbers = Game.OtherUsersNumbers
				fmt.Println(response)

			case model.TypeResetGame:
				// レスポンス作成
				response.Type = model.TypeResetGame
			}
			// Client からのメッセージを元に返すメッセージを作成し送信する
			err = sendMessageToAllPool(*response)
			if err != nil {
				c.Logger().Error(err)
				// ユーザーの情報を削除する
				removeUser(request.UserID)
				break
			}
		}
	}).ServeHTTP(c.Response(), c.Request())

	err := <-errorHandler
	return err
}

// sendMessageToAllPool 全てのコネクションが貼られているユーザーにresponseを送信する
func sendMessageToAllPool(response model.Response) error {
	connectionPool.RLock()
	defer connectionPool.RUnlock()
	for connection := range connectionPool.connections {
		if err := websocket.JSON.Send(connection, response); err != nil {
			fmt.Println("errorSocket コネクションがすでに切断されている可能性あり")
			// コネクションの削除は後処理で行うためここでは行わない
			//connectionPool.Lock()
			//delete(connectionPool.connections, connection)
			//connectionPool.Unlock()
			return err
		}
	}
	return nil
}

// 指定されたIDのUsersを削除する
func removeUser(id int) {
	var after []model.User
	for _, user := range Users {
		if user.Id != id {
			after = append(after, user)
		}
	}
	Users = after
}

type TestStruct struct {
	Text string `json:"text"`
	Data string `json:"data"`
}

func TestMethod() echo.HandlerFunc {
	return func(context echo.Context) error {
		var test = TestStruct{
			Text: "test",
			Data: "aaaa",
		}

		return context.JSON(http.StatusOK, test)
	}
}

// 初期化を行う
func GameReset() echo.HandlerFunc {
	return func(context echo.Context) error {
		// 空配列をセットする
		Users = []model.User{}
		Game = model.Game{
			Theme:             "",
			OtherUsersNumbers: []model.User{},
		}
		IdSeq = 0
		service.ResetNumber()
		fmt.Println("ゲームリセット")
		return context.String(http.StatusOK, "OK")
	}
}

// ユーザーIDの再番を行う
func GetUserId() echo.HandlerFunc {
	return func(context echo.Context) error {
		IdSeq++
		fmt.Println(fmt.Sprintf("採番されたUserID:%d", IdSeq))
		return context.String(http.StatusOK, strconv.Itoa(IdSeq))
	}
}

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	//こいつを追加
	e.Use(middleware.CORS())

	e.Static("/", "public")
	api := e.Group("/api")
	{
		api.GET("/gameStart", handleWebSocket)
		api.GET("/getId", GetUserId())
		api.GET("/reset", GameReset())
	}
	e.Logger.Fatal(e.Start(":6785"))
}
