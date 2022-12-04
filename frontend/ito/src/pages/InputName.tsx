import React, { useState, useCallback } from 'react';
import '../css/InputName.css';
import axios from "axios";
import { useHistory } from 'react-router-dom'
import Explanation from '../component/Explanation';
import Button from '../component/Button';
import InputText from '../component/InputText';
import { getApiUrl } from '../common/config';
import WebSockets from "../class/WebSockets";

/**
 * ゲーム説明＋名前入力画面
 * @returns {React.ReactElement}
 */
const InputName: React.FC = () => {
  // const [変数名, Stateを更新するための関数(set変数名)] = useState<型>(初期値)としている
  const [userName, setUserName] = useState<string>("");   // ユーザが入力する名前
  // react-router-dom: [https://qiita.com/ozaki25/items/bb0eb273611eebc603dd]
  const history = useHistory();   // 画面遷移＋stateを画面遷移先に渡す

  // inputが入力を検知したら発火する関数
  // useCallbackは、前回の値を保持していて差分を比較して更新部分があれば発火する。
  const inputUserName = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setUserName(e.target.value)
  },[setUserName]);

  //
  const sendHistory = async () => {
    if(!userName){ return } // ユーザネームが空の時、何もしない。
    // インスタンスが作成されているか確認
    if (WebSockets.checkMakeInstance()) {
        // すでに作成済みの場合はコネクションを一度閉じる
        console.log("インスタンス作成済み")
        // websocketが生成済みの場合は破棄を行う
        WebSockets.closeSocket()
    }
    // axios: サーバーとやり取りを行うライブラリ
    // await axios.get<string>(`${PROD_GOLANG_URL.key}/getId`)
    await axios.get<string>(`${getApiUrl().key}/getId`)
      .then((res) => {
        history.push({
          pathname: '/game',
          state: {
            userName: userName,
            userId: parseInt(res.data)
          } // /gameに画面遷移＋stateを渡す。
        });
      })
      .catch((err) => {
        // エラー処理
        console.log("失敗");
      })
  }

  return (
    <>
      <h1>ito</h1>
      <Explanation />
      <div className="username-wrap">
        <InputText    // 子コンポーネントへpropsとして値を渡す
          className="username-textbox"
          placeholder="user name"
          type="text"
          inputUserName={(e) => inputUserName(e)}
        />
      </div>
      <Button onClickFunction={sendHistory} text="自分の数字を見る" />
    </>
  );
}

export default InputName;