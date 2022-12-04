import React, {useState, useCallback, useEffect} from 'react';
import WebSockets from '../class/WebSockets';
import { themes } from '../data/themes';
import Button from '../component/Button';
import axios from 'axios';
import { getApiUrl } from '../common/config';

/**
 * 管理者の画面 選択したお題を参加者へ送る。
 * @returns {React.ReactElement}
 */
const Admin: React.FC = () => {
    // useState: 参考URL[https://qiita.com/seira/items/f063e262b1d57d7e78b4]
    const [odai, setOdai] = useState<string>("");

    let webSocket: WebSocket = WebSockets.getInstance();
    // ゲームスタート
    const startWsConnect = () => {
        if (!WebSockets.checkMakeInstance()) {
            // 再度コネクションを貼る
            webSocket = WebSockets.getInstance()
        }
    }

    // useCallBack: 参考URL[https://qiita.com/seira/items/8a170cc950241a8fdb23]
    const handleChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
        setOdai(e.target.value)
    }, [setOdai])

    const themeAnnounce = () => {
        if(!odai){ return false }

        // コネクション切れが発生するため再接続
        if (!WebSockets.checkMakeInstance()) {
          // 再度コネクションを貼る
          webSocket = WebSockets.getInstance()
        }
        // タイプ 0:お題 1:数字発表 2:ユーザー名 3:ゲームリセット
        WebSockets.sendWebSocket(0, 0, "", 0, odai)
    }

    const gameReset = async () => {
        await axios.get(`${getApiUrl().key}/reset`)
          .then((res) => {
              console.log("ゲームリセット")

              // コネクション切れが発生するため再接続
              if (!WebSockets.checkMakeInstance()) {
                // 再度コネクションを貼る
                webSocket = WebSockets.getInstance()
              }
              // タイプ 0:お題 1:数字発表 2:ユーザー名 3:ゲームリセット
              WebSockets.sendWebSocket(3, 0, "", 0, "")
              window.location.reload();
          })
          .catch(res => {
            console.log("error");
          })
    }

    useEffect(() => {
        startWsConnect()
    })

    return (
    <div>
      <h1>ito</h1>
      <p>GMの画面だよ</p>
      {
        themes.map(theme => (
          <p key={theme}>
            <input
              type="radio"
              name="selectTheme"
              value={theme}
              onChange={(e) => handleChange(e)}
            />{theme}
          </p>
        ))
      }
      <Button
       text="お題を発表する"
       onClickFunction={() => themeAnnounce()}
      />
      <div style={{textAlign: 'center', marginTop: '0px'}}>
        <Button
         text="リセット"
         onClickFunction={() => gameReset()}
        />
      </div>
    </div>
    );
}

export default Admin;