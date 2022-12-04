import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import WebSockets from '../class/WebSockets';
import { getApiUrl } from '../common/config';
import NumberCard from '../component/NumberCard';
import '../css/StartGame.css';
import { UsersNumbersType } from '../types/UsersNumbersType';
import { DataType } from '../types/DataType';
import { ReceiveData } from '../types/ReceiveData';

/**
 * ゲーム画面 WebSocketが値を送ったり、受け取ったりする。
 * @returns {React.ReactElement}
 */
const Game: React.FC = () => {
  // WebSocketを取得
  let webSocket: WebSocket = WebSockets.getInstance();
  // 画面遷移用(react-router-dom)でstateを画面遷移元から取得する
  const location = useLocation();
  const state = location.state as {userId: number, userName: string}  // 受け取る値の型に変換する
  // const [userId, setUserId] = useState<number>(state.userId);         // 自分のID
  const [userName, setUserName] = useState<string>(state.userName);   // 自分の名前
  const [myNumber, setMyNumber] = useState<number>(0);    // 自分の番号
  const [otherUsersNumbers, setOtherUsersNumbers] = useState<UsersNumbersType[]>([]); // 他のユーザの情報を格納する配列
  const [theme, setTheme] = useState<string>("");         // お題
  const [isSend, setIsSend] = useState<boolean>(false);   // ボタンを活性化 or 非活性化にする

  let userId = state.userId;

  // ゲームスタート
  const startWsConnect = () => {
    if (!WebSockets.checkMakeInstance()) {
      // 再度コネクションを貼る
      webSocket = WebSockets.getInstance()
      // onopenとは、WebSocketのコネクションが確立したときに発火する関数
      webSocket.onopen = () => {
        WebSockets.sendWebSocket(2, userId, userName, myNumber, "")
      }
    }
  }

  // 自分のカードを公開する
  const sendMyNumber = () => {
    // コネクション切れが発生するため再接続
    if (!WebSockets.checkMakeInstance()) {
      // 再度コネクションを貼る
      webSocket = WebSockets.getInstance()
    }
    setIsSend(true)   // 二重送信防止用
    WebSockets.sendWebSocket(1, userId, userName, myNumber, "")
  }

  // 受け取るデータに応じて処理を変えている。
  // useEffect: 参考URL[https://qiita.com/seira/items/e62890f11e91f6b9653f]
  useEffect( () => {
    startWsConnect();
    // websocketが受信したら呼ばれる
    webSocket.onmessage = async (e: MessageEvent<any>) => {
      const data: ReceiveData = JSON.parse(e.data);
      if(data.type === DataType.TypeResetGame) {
        await axios.get<string>(`${getApiUrl().key}/getId`)
          .then( (res) => {
            setIsSend(false)
            // setUserId(parseInt(res.data))
            userId = parseInt(res.data)
            // コネクション切れが発生するため再接続
            if (!WebSockets.checkMakeInstance()) {
              // 再度コネクションを貼る
              webSocket = WebSockets.getInstance()
            }
            WebSockets.sendWebSocket(2, parseInt(res.data), userName, 0, "")
          })
          .catch( (err) => {
          })
      } else if (data.type === DataType.TypeUser) {
        if (userId === data.id) {
          // setUserId(data.id)
          userId = data.id
          setMyNumber(data.number!)
          setUserName(data.user_name!)
          setTheme(data.theme!)
          setOtherUsersNumbers(data.other_users_numbers!.map((data: any) => {
            return {
              "number": data.number,
              "user_name": data.user_name
            }
          }))
        }
      } else if (data.type === DataType.TypeNumber) {
        setOtherUsersNumbers(data.other_users_numbers!.map((data: any) => {
          return {
            "number": data.number,
            "user_name": data.user_name
          }
        }))
      } else if (data.type === DataType.TypeTheme) {
        setTheme(data.theme!)
      }
    };
  }, [])

  return (
    <div>
      <div className="number-card-area">
        {otherUsersNumbers.map((data, key) => (
          <NumberCard
            key={key}  // mapを使ってjsxを表示する際には[key={一位な値}]を設定する。
            number={data.number} // 子コンポーネントで(props.number)で参照することができる
            user_name={data.user_name}
          />
        ))}
      </div>

      <div className="contents">
        <h2>今回のお題</h2>
        <div>『{theme}』</div>
        <div className="your-number">あなたの数字は{myNumber}です。</div>

        <button
          disabled={isSend}
          onClick={() => sendMyNumber()}
        >
          数字を発表する
        </button>
      </div>
    </div>
  );
}

export default Game;