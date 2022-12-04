
BUCKET_DEPLOY="prod-job-ito-deploy"
BUCKET_PIPELINE="prod-job-ito-pipeline"


## バケット作成
aws s3api create-bucket --bucket ${BUCKET_DEPLOY} --create-bucket-configuration LocationConstraint=${REGION}
aws s3api create-bucket --bucket ${BUCKET_PIPELINE} --create-bucket-configuration LocationConstraint=${REGION}


# 暗号化を有効にする
aws s3api put-bucket-encryption --bucket ${BUCKET_DEPLOY} --server-side-encryption-configuration 'Rules={ApplyServerSideEncryptionByDefault={SSEAlgorithm=AES256}}'

# バージョニングを有効にする
aws s3api put-bucket-versioning --bucket ${BUCKET_DEPLOY} --versioning-configuration "MFADelete=Disabled, Status=Enabled"

# role権限のみでアクセスされるものは非公開設定にする
aws s3api put-public-access-block --bucket ${BUCKET_DEPLOY} --public-access-block-configuration "BlockPublicAcls=true, IgnorePublicAcls=true, BlockPublicPolicy=true, RestrictPublicBuckets=true"
aws s3api put-public-access-block --bucket ${BUCKET_PIPELINE} --public-access-block-configuration "BlockPublicAcls=true, IgnorePublicAcls=true, BlockPublicPolicy=true, RestrictPublicBuckets=true"
