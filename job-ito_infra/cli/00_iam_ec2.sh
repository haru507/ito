
### IAMロール作成用ファイル
cat << 'EOF' | tee role-ec2-base.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

cat << 'EOF' | tee rp-s3-deploy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::codepipeline-ap-northeast-1-727953066275",
                "arn:aws:s3:::codepipeline-ap-northeast-1-727953066275/*"
            ]
        }
    ]
}
EOF

aws iam create-role --role-name role-${ENV_NAME}-${SYSTEM_NAME}-job-ito --assume-role-policy-document file://role-ec2-base.json
aws iam put-role-policy --role-name role-${ENV_NAME}-${SYSTEM_NAME}-job-ito --policy-name rp-${ENV_NAME}-${SYSTEM_NAME}_s3-deploy --policy-document file://rp-s3-deploy.json
aws iam create-instance-profile --instance-profile-name role-${ENV_NAME}-${SYSTEM_NAME}-job-ito
aws iam add-role-to-instance-profile --instance-profile-name role-${ENV_NAME}-${SYSTEM_NAME}-job-ito --role-name role-${ENV_NAME}-${SYSTEM_NAME}-job-ito