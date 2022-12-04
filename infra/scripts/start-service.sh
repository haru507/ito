#!/bin/bash

# 設定ファイルの再読み込み
systemctl daemon-reload

# サービスの自動起動有効化
systemctl enable job-ito.service

# Go起動
systemctl start job-ito.service

# nginx起動
systemctl start nginx