// .envの型定義
type _Config = {
    key: string
}

// .env から値を取得するときは[string | undefined]になっているため、stringに変換している
const DEV_GOLANG_URL: _Config = {
    key: process.env.REACT_APP_DEV_GOLANG_URL || ""
}

const PROD_GOLANG_URL: _Config = {
    key: process.env.REACT_APP_PROD_GOLANG_URL || ""
}

const DEV_WEBSOCKET_URL: _Config = {
    key: process.env.REACT_APP_DEV_WEBSOCKET_URL || ""
}

const PROD_WEBSOCKET_URL: _Config = {
    key: process.env.REACT_APP_PROD_WEBSOCKET_URL || ""
}

const env = process.env.REACT_APP_ENV

export const getApiUrl = (): _Config  => {
    console.log(env)
    if (env === "local") {
        return DEV_GOLANG_URL
    } else {
        return PROD_GOLANG_URL
    }
}

export const getWebSocketUrl = (): _Config  => {
    console.log(env)
    if (env === "local") {
        return DEV_WEBSOCKET_URL
    } else {
        return PROD_WEBSOCKET_URL
    }
}