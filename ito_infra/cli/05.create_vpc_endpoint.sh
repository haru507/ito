
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag-key,Values=Name --filters Name=tag-value,Values=job-training-vpc | jq -r '.Vpcs[].VpcId')
ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables | jq -r --arg VPC_ID ${VPC_ID} '.RouteTables[] | select(.VpcId == $VPC_ID).RouteTableId')


# ### インターフェース型VPCエンドポイントが必要な場合、東スポスクリプトを確認して作成する。


### VPCエンドポイントの作成

# S3
VPC_S3_ENDPOINT_ID=$(aws ec2 create-vpc-endpoint --vpc-id ${VPC_ID} --service-name com.amazonaws.${REGION}.s3 | jq -r '.VpcEndpoint.VpcEndpointId')
echo "VPC_S3_ENDPOINT_ID=${VPC_S3_ENDPOINT_ID}"
aws ec2 modify-vpc-endpoint --vpc-endpoint-id ${VPC_S3_ENDPOINT_ID} --add-route-table-ids ${ROUTE_TABLE_IDS}

aws ec2 describe-vpc-endpoints
#=============================
# {
#     "VpcEndpoints": [
#         {
#             "VpcEndpointId": "vpce-0aca585115c21517f",
#             "VpcEndpointType": "Gateway",
#             "VpcId": "vpc-0b8d3e3be52c1c991",
#             "ServiceName": "com.amazonaws.ap-northeast-1.s3",
#             "State": "available",
#             "PolicyDocument": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"*\",\"Resource\":\"*\"}]}",
#             "RouteTableIds": [
#                 "rtb-0d800c9719a1c93d0",
#                 "rtb-0930d494038cd27df"
#             ],
#             "SubnetIds": [],
#             "Groups": [],
#             "PrivateDnsEnabled": false,
#             "RequesterManaged": false,
#             "NetworkInterfaceIds": [],
#             "DnsEntries": [],
#             "CreationTimestamp": "2022-03-24T04:43:28+00:00",
#             "Tags": [],
#             "OwnerId": "780612155571"
#         }
#     ]
# }
#=============================
