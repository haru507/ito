
APPLICATION_NAME="${ENV_NAME}_${SYSTEM_NAME}"
BUCKET_DEPLOY="${ENV_NAME}-${SYSTEM_NAME}-deploy"

DEPLOYMENTGROUP_NAME="${ENV_NAME}_${SYSTEM_NAME}"
PIPELINE_NAME="${ENV_NAME}_${SYSTEM_NAME}"
SRC_PASS="${ENV_NAME}-${SYSTEM_NAME}/${ENV_NAME}-${SYSTEM_NAME}.zip"
PIPELINE_BUCKET="${ENV_NAME}-${SYSTEM_NAME}-pipeline"
BUILD_NAME="${ENV_NAME}_${SYSTEM_NAME}-build"



cat << 'EOF' | tee role-codepipeline.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

cat << 'EOF' | tee rp-codepipeline.json
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:Update${ENV_NAME}uct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF

aws iam create-role --role-name CodePipelineServiceRole2 --assume-role-policy-document file://role-codepipeline.json
aws iam put-role-policy --role-name CodePipelineServiceRole2 --policy-name AWSCodePipelineServiceRole2 --policy-document file://rp-codepipeline.json

SERVICEROLE_ARN=$(aws iam get-role --role-name CodePipelineServiceRole --query "Role.Arn" --output text)


### pipeline作成
cat << EOF | tee codepipeline.json
{
  "pipeline": {
    "roleArn": "${SERVICEROLE_ARN}",
    "stages": [
      {
        "name": "Source",
        "actions": [
          {
            "inputArtifacts": [],
            "name": "Source",
            "actionTypeId": {
              "category": "Source",
              "owner": "AWS",
              "version": "1",
              "provider": "CodeCommit"
            },
            "outputArtifacts": [
              {
                "name": "SourceArtifact"
              }
            ],
            "Configuration": {
              "RepositoryName": "job-ito",
              "BranchName": "main",
              "PollForSourceChanges": "false"
            },
            "runOrder": 1
          }
        ]
      },
      {
        "name": "Approval",
        "actions": [
          {
            "inputArtifacts": [],
            "name": "Approval",
            "region": "${REGION}",
            "actionTypeId": {
              "category": "Approval",
              "owner": "AWS",
              "version": "1",
              "provider": "Manual"
            },
            "outputArtifacts": [],
            "configuration": {},
            "runOrder": 1
          }
        ]
      },
      {
        "name": "Build",
        "actions": [
          {
            "name": "Build",
            "actionTypeId": {
              "category": "Build",
              "owner": "AWS",
              "provider": "CodeBuild",
              "version": "1"
            },
            "runOrder": 1,
            "configuration": {
              "ProjectName": "${BUILD_NAME}"
            },
            "outputArtifacts": [
              {
                "name": "BuildArtifact"
              }
            ],
            "inputArtifacts": [
              {
                "name": "SourceArtifact"
              }
            ],
            "region": "${REGION}",
            "namespace": "BuildVariables"
          }
        ]
      },
      {
        "name": "Deploy",
        "actions": [
          {
            "inputArtifacts": [
              {
                "name": "SourceArtifact"
              }
            ],
            "name": "Deploy",
            "actionTypeId": {
              "category": "Deploy",
              "owner": "AWS",
              "version": "1",
              "provider": "CodeDeploy"
            },
            "outputArtifacts": [],
            "configuration": {
              "ApplicationName": "${APPLICATION_NAME}",
              "DeploymentGroupName": "${DEPLOYMENTGROUP_NAME}"
            },
            "runOrder": 1
          }
        ]
      }
    ],
    "artifactStore": {
      "type": "S3",
      "location": "${PIPELINE_BUCKET}"
    },
    "name": "${PIPELINE_NAME}",
    "version": 1
  }
}
EOF

aws codepipeline create-pipeline --cli-input-json file://codepipeline.json


### S3の検知イベントを追加する

# 1. AWS管理コンソールを開く

# 2. 作成したパイプラインのページに移動

# 3. 「編集」から「Source」ステージの編集画面に移動

# 4. 「検出オプションを変更する」が「Amazon CloudWatch Events」になっていることを確認して「完了」

# 5. 「保存」をクリックして以下が表示されることを確認する
#     追加する	Amazon CloudWatch Events ルールおよびパイプライン ${ENV_NAME}_${SYSTEM_NAME} 用の AWS CloudTrail データイベント

# 6. 「保存」を実行




