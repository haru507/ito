
# リポジトリ作成
aws codecommit create-repository \
 --repository-name ${SYSTEM_NAME} \
 --repository-description "ジョブトレで使うITOの自動デプロイ発火用のリポジトリ"\
 --region ${REGION}

# {
#     "repositoryMetadata": {
#         "accountId": "850987806830",
#         "repositoryId": "44665e7a-f74c-4de6-8a6d-45ca4d5f1057",
#         "repositoryName": "job-ito",
#         "repositoryDescription": "ジョブトレで使うITOの自動デプロイ発火用のリポジトリ",
#         "lastModifiedDate": "2022-07-11T18:14:16.882000+09:00",
#         "creationDate": "2022-07-11T18:14:16.882000+09:00",
#         "cloneUrlHttp": "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/job-ito",
#         "cloneUrlSsh": "ssh://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/job-ito",
#         "Arn": "arn:aws:codecommit:ap-northeast-1:850987806830:job-ito"
#     }
# }

### CodeCommit作成後に鍵の生成を行う。 -C: コメント
# ssh-keygen -t rsa -b 4096 -C "h.ishii@tcdigital.jp"

# ここでパスフレーズは空でOK 何か入力を行うとGitHub Actionsでエラーが出る。


# AWS CodeCommitとGitHubに鍵を登録する。（URL参照）