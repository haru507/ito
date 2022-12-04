BUCKET_DEPLOY="${ENV_NAME}-${SYSTEM_NAME}-deploy"

BUILD_NAME="${ENV_NAME}_${SYSTEM_NAME}-build"
### CodeCommitのURL？
SRC_PATH="https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/job-ito"

### サービスロール ARN作成
cat << 'EOF' | tee role-codebuild.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codebuild.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

cat << 'EOF' | tee rp-codebuild.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogsPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "CodeCommitPolicy",
            "Effect": "Allow",
            "Action": [
                "codecommit:GitPull"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "S3ListBucketPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "S3GetObjectPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF

aws iam create-role --role-name CodeBuildServiceRole --assume-role-policy-document file://role-codebuild.json
aws iam put-role-policy --role-name CodeBuildServiceRole --policy-name CodeBuildServiceRolePolicy --policy-document file://rp-codebuild.json


### codebuild作成
CODEBUILD_SERVICEROLE_ARN=$(aws iam get-role --role-name CodeBuildServiceRole --query "Role.Arn" --output text)


cat << EOF | tee codebuild-${BUILD_NAME}.json
{
  "name": "${BUILD_NAME}",
  "source": {
    "type": "CODECOMMIT",
    "location": "${SRC_PATH}"
  },
  "artifacts": {
    "type": "NO_ARTIFACTS"
  },
  "cache": {
    "type": "NO_CACHE"
  },
  "environment": {
    "type": "LINUX_CONTAINER",
    "image": "aws/codebuild/amazonlinux2-x86_64-standard:3.0",
    "computeType": "BUILD_GENERAL1_SMALL",
    "imagePullCredentialsType": "CODEBUILD"
  },
  "serviceRole": "${CODEBUILD_SERVICEROLE_ARN}"
}
EOF

aws codebuild create-project --cli-input-json file://codebuild-${BUILD_NAME}.json



