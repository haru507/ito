
APPLICATION_NAME="${ENV_NAME}_${SYSTEM_NAME}"

DEPLOYMENTGROUP_NAME="${ENV_NAME}_${SYSTEM_NAME}"
EC2_TAG_VALUE="job-training-ec2-1"

### サービスロール ARN作成
cat << 'EOF' | tee role-codedeploy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

aws iam create-role --role-name CodeDeployServiceRole --assume-role-policy-document file://role-codedeploy.json
aws iam attach-role-policy --role-name CodeDeployServiceRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole

SERVICEROLE_ARN=$(aws iam get-role --role-name CodeDeployServiceRole --query "Role.Arn" --output text)


### アプリケーション作成
aws deploy create-application --application-name ${APPLICATION_NAME}


### デプロイグループ作成
aws deploy create-deployment-group \
 --application-name ${APPLICATION_NAME} \
 --deployment-group-name ${DEPLOYMENTGROUP_NAME} \
 --deployment-config-name CodeDeployDefault.AllAtOnce \
 --ec2-tag-filters Key=Name,Type=KEY_AND_VALUE,Value=${EC2_TAG_VALUE} \
 --service-role-arn ${SERVICEROLE_ARN}
