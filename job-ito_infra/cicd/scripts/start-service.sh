#!/bin/bash

REGION="ap-northeast-1"
ENV_NAME="prod"
APP_NAME="bspapp_appserver"
FILENAME=".env"

systemctl start awslogsd
systemctl start nginx
systemctl start php-fpm


# 以降、DB Migration等はデプロイ終了後に行う