# ito 環境構築

dockerコンテナ起動
```
$ docker-compose up -d
```

### フロントエンドのアプリ起動
フロントエンドのコンテナに接続
```
$ docker-compose exec frontend sh
```

ソースがあるディレクトリに移動
```
$ cd ito
```

node modules作成
```
$ npm ci
```

アプリ起動
```
$ npm start
```

`http://localhost:3332/start`にアクセスして画面が表示されれば完了

### バックエンドのアプリ起動
バックエンドのコンテナに接続
```
$ docker-compose exec go_job bash
```

アプリ起動
```
$ go run main.go
```

ゲーム開始するにはバックエンドのアプリを起動すること。

