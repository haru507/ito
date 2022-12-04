import { getWebSocketUrl } from "../common/config"

// WebSocketをクラス化
class WebSockets {
    // WebSocketのインスタンス格納場所
    private static _instance: WebSocket | undefined
    // new WebSocket()ができないようにprivateにしている
    private constructor(){}

    // シングルトンパターン
    public static getInstance(): WebSocket {
        // インスタンスが生成されているかの判定
        if(!this._instance) {
            // 初回時のみインスタンス生成
            this._instance = new WebSocket(`${getWebSocketUrl().key}/gameStart`)
        }
        return this._instance;
    }

    /**
     * コネクションをクローズし、WebSocketのインスタンスを削除する
     * @return Promise<boolean> 削除結果
     */
    public static async closeSocket(): Promise<boolean> {
        if (!this._instance) return true
        this._instance.close()
        try {
            const ev = await this._instance.onclose
            this._instance = undefined
            console.log(ev)
            console.log("コネクション切断")
            return true
        } catch (error) {
            return false
        }
    }

    /**
     * インスタンスが作成済みか確認する
     * @return boolean インスタンス作成済みかどうか
     */
    public static checkMakeInstance(): boolean {
        let isInstance: boolean = false
        if (WebSockets._instance?.readyState === WebSockets._instance?.OPEN) {
            isInstance = true
        }
        
        return isInstance;
    }

    // 受け取った値をサーバー（Golang）のWebSocketに送信する。
    static sendWebSocket(
        type: number,
        userId: number,
        userName: string,
        myNumber: number,
        odai: string
    ): void {
        // インスタンスが作られていなければ即時return
        // TODO: 起きた時どうしよ
        if (
            WebSockets._instance?.readyState === WebSockets._instance?.CLOSED ||
            WebSockets._instance?.readyState === WebSockets._instance?.CLOSING
        ) { 
            WebSockets.getInstance()
        }
        // staticを使っているため、this(✖️)、class名(○)
        WebSockets._instance?.send(JSON.stringify({
            "type":type,
            "user_id":userId,
            "user_name":userName,
            "number":myNumber,
            "odai":odai
        }))
    }
}

export default WebSockets
