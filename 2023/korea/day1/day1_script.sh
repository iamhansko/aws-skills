#!/bin/bash

echo -e "\033[33mCloudFront Distribution ID를 입력하세요.\033[0m"
read DistributionID

echo -e "\033[33map-northeast-2 버킷 이름을 입력하세요.(ap-wsi-static-xxxx)\033[0m"
read AP_BUCKET

echo -e "\033[33mus-east-1 버킷 이름을 입력하세요.(us-wsi-static-xxxx)\033[0m"
read US_BUCKET

export CF_DOMAIN=$(aws cloudfront get-distribution --id ${DistributionID} --query "Distribution.DomainName" | sed s/\"//g)
export LB_DOMAIN=$(aws elbv2 describe-load-balancers --names "wsi-alb" --query "LoadBalancers[0].DNSName" | sed s/\"//g)

aws configure set default.region ap-northeast-2
export InvalidationID=$(aws cloudfront create-invalidation --distribution-id ${DistributionID} --paths "/*" --query "Invalidation.Id" | sed s/\"//g)
aws cloudfront wait invalidation-completed --distribution-id ${DistributionID} --id ${InvalidationID}
aws s3 rm --quiet --recursive s3://$AP_BUCKET/
aws s3 rm --quiet --recursive s3://$US_BUCKET/

echo -e "\033[32m"---------- 1\-1 ----------"\033[0m"
echo -e "\033[32m"10.1.0.0/16이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-vpcs --filter Name=tag:Name,Values=wsi-vpc --query "Vpcs[0].CidrBlock"
echo -e "\033[32m"10.1.0.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-app-a --query "Subnets[0].CidrBlock"
echo -e "\033[32m"10.1.1.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-app-b --query "Subnets[0].CidrBlock"
echo -e "\033[32m"10.1.2.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[0].CidrBlock"
echo -e "\033[32m"10.1.3.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-b --query "Subnets[0].CidrBlock"
echo -e "\033[32m"10.1.4.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-data-a --query "Subnets[0].CidrBlock"
echo -e "\033[32m"10.1.5.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-data-b --query "Subnets[0].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-2 ----------"\033[0m"
echo -e "\033[32m"1이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-app-a-rt --query "RouteTables[].Routes[].NatGatewayId" | grep "nat-" | wc -l
echo -e "\033[32m"1이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-app-b-rt --query "RouteTables[].Routes[].NatGatewayId"  | grep "nat-" | wc -l
echo -e "\033[32m"1이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-public-rt --query "RouteTables[].Routes[]" | grep "igw-" | wc -l
echo -e "\033[32m"0이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-data-rt --query "RouteTables[].Routes[]" | grep -E "igw-|nat-" | wc -l
echo -e "\n"

echo -e "\033[32m"---------- 1\-3 ----------"\033[0m"
echo -e "\033[32m"com.amazonaws.ap-northeast-2.s3, com.amazonaws.ap-northeast-2.ecr.api, com.amazonaws.ap-northeast-2.ecr.dkr이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-vpc-endpoints --query "VpcEndpoints[].ServiceName"
echo -e "\n"

echo -e "\033[32m"---------- 2\-1 ----------"\033[0m"
echo -e "\033[32m"t3.small이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion --query "Reservations[0].Instances[0].InstanceType"
echo -e "\n"

echo -e "\033[32m"---------- 2\-2 ----------"\033[0m"
echo -e "\033[32m"wsi-bastion-sg, 4272가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion --query "Reservations[0].Instances[0].SecurityGroups[0].GroupName"
aws ec2 describe-security-groups --filter Name=group-name,Values=wsi-bastion-sg --query "SecurityGroups[0].IpPermissions[].{FromPort:FromPort,ToPort:ToPort,IpRanges:IpRanges}"
echo -e "\n"

echo -e "\033[32m"---------- 2\-3 ----------"\033[0m"
echo -e "\033[32m"4272가 출력되는지 확인합니다."\033[0m"
export SGID=$(aws ec2 describe-security-groups --filter Name=group-name,Values=wsi-bastion-sg --query "SecurityGroups[0].GroupId" | sed s/\"//g)
aws ec2 authorize-security-group-ingress --group-id $SGID --protocol tcp --port 22 --cidr 0.0.0.0/0
sleep 60
aws ec2 describe-security-groups --filter Name=group-name,Values=wsi-bastion-sg --query "SecurityGroups[0].IpPermissions[].{FromPort:FromPort,ToPort:ToPort,IpRanges:IpRanges}"
echo -e "\n"

echo -e "\033[32m"---------- 3\-1 ----------"\033[0m"
echo -e "\033[32m"Engine:mysql, MultiAZ:true, DBInstanceClass:db.t3.medium이 출력되는지 확인합니다."\033[0m"
aws rds describe-db-instances --db-instance-identifier wsi-rds-instance --query "DBInstances[0].{Engine:Engine,MultiAZ:MultiAZ,DBInstanceStatus:DBInstanceStatus,DBInstanceClass:DBInstanceClass,StorageEncrypted:StorageEncrypted}"
echo -e "\n"

echo -e "\033[32m"---------- 4\-1 ----------"\033[0m"
echo -e "\033[32m"The product is well in database, 200이 출력되는지 확인합니다."\033[0m"
curl -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/product?name=p-H8ds73vW4liO
echo -e "\n"

echo -e "\033[32m"---------- 4\-2 ----------"\033[0m"
echo -e "\033[32m"200, 201이 출력되는지 확인합니다."\033[0m"
curl -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress
curl -X POST -H "Content-Type: application/json" -d '{"iterator": 1}' --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress
echo -e "\n"

echo -e "\033[32m"---------- 5\-1 ----------"\033[0m"
echo -e "\033[32m"FARGATE가 출력되는지 확인합니다."\033[0m"
aws ecs describe-services --cluster wsi-ecs-cluster --services "stress" --query "services[0].capacityProviderStrategy[].capacityProvider"
echo -e "\n"

echo -e "\033[32m"---------- 5\-2 ----------"\033[0m"
echo -e "\033[32m"cpu:512, memory:1024가 출력되는지 확인합니다."\033[0m"
export TaskDefinition=$(aws ecs describe-services --cluster wsi-ecs-cluster --services "stress" --query "services[0].deployments[0].taskDefinition" | sed s/\"//g)
aws ecs describe-task-definition --task-definition $TaskDefinition --query "taskDefinition.{memory:memory,cpu:cpu}"
echo -e "\n"

echo -e "\033[32m"---------- 5\-3 ----------"\033[0m"
echo -e "\033[32m"0, 1이 출력되는지 확인합니다."\033[0m"
export TaskDefinition=$(aws ecs describe-services --cluster wsi-ecs-cluster --services "product" --query "services[0].deployments[0].taskDefinition" | sed s/\"//g)
aws ecs describe-task-definition --task-definition $TaskDefinition --query "taskDefinition.containerDefinitions[].environment" | grep dbinfo | wc -l
aws ecs describe-task-definition --task-definition $TaskDefinition --query "taskDefinition.containerDefinitions[].secrets" | grep dbinfo | wc -l
echo -e "\n"

echo -e "\033[32m"---------- 6\-1 ----------"\033[0m"
echo -e "\033[32m"404 Contents Not Found가 출력되는지 확인합니다."\033[0m"
export LoadBalancerArn=$(aws elbv2 describe-load-balancers --names "wsi-alb" --query "LoadBalancers[0].LoadBalancerArn" | sed s/\"//g)
aws elbv2 describe-listeners --load-balancer-arn $LoadBalancerArn --query "Listeners[0].DefaultActions"
echo -e "\033[32m"\/v1\/stress, \/v1\/product가 출력되는지 확인합니다."\033[0m"
export LoadBalancerArn=$(aws elbv2 describe-load-balancers --names "wsi-alb" --query "LoadBalancers[0].LoadBalancerArn" | sed s/\"//g)
export ListenerArn=$(aws elbv2 describe-listeners --load-balancer-arn 
$LoadBalancerArn --query "Listeners[0].ListenerArn" | sed s/\"//g)
aws elbv2 describe-rules --listener-arn $ListenerArn --query "Rules[].Conditions[].{Field:Field, Values:Values}"
echo -e "\n"

echo -e "\033[32m"---------- 6\-2 ----------"\033[0m"
echo -e "\033[32m"Connection timed out after 5000 milliseconds, 000이 출력되는지 확인합니다."\033[0m"
curl http://${LB_DOMAIN}/v1/stress -w \\n%{http_code}\\n --max-time 5
echo -e "\033[32m"version:v1.0, 200이 출력되는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 7\-1 ----------"\033[0m"
echo -e "\033[32m"S3 버킷 이름이 출력되는지 확인합니다."\033[0m"
aws s3 ls | grep -E "ap-wsi-static|us-wsi-static"
echo -e "\n"

echo -e "\033[32m"---------- 7\-2 ----------"\033[0m"
echo -e "\033[32m"testobject-us.txt, testobject-ap.txt가 출력되는지 확인합니다."\033[0m"
cat << EOF >> testobject-ap.txt
This is testobject for marking that uploaded to AP-NORHTEAST-2.
EOF
cat << EOF >> testobject-us.txt
This is testobject for marking that uploaded to US-EAST-1.
EOF
aws s3 cp --quiet testobject-ap.txt s3://$AP_BUCKET/static/
aws s3 cp --quiet testobject-us.txt s3://$US_BUCKET/static/
sleep 60
aws s3 ls s3://$AP_BUCKET/static/ | grep 'testobject-us.txt'
aws s3 ls s3://$US_BUCKET/static/ | grep 'testobject-ap.txt'
echo -e "\n"

echo -e "\033[32m"---------- 7\-3 ----------"\033[0m"
echo -e "\033[32m"aws:kms가 출력되는지 확인합니다."\033[0m"
aws s3api get-bucket-encryption --bucket $AP_BUCKET --query ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm
aws s3api get-bucket-encryption --bucket $US_BUCKET --query ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm
echo -e "\n"

echo -e "\033[32m"---------- 8\-1 ----------"\033[0m"
echo -e "\033[32m"Miss from cloudfront, 200이 출력되는지 확인합니다."\033[0m"
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress | grep -iE "x-cache:|^200$"
sleep 30
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress | grep -iE "x-cache:|^200$"
echo -e "\n"

echo -e "\033[32m"---------- 8\-2 ----------"\033[0m"
echo -e "\033[32m"Miss from cloudfront, 200이 출력되는지 확인합니다."\033[0m"
cat << EOF >> testobject-cdn.txt
This is testobject for marking that CDN perform.
EOF
aws s3 cp --quiet testobject-cdn.txt s3://$AP_BUCKET/static/
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/static/testobject-cdn.txt | grep -iE "x-cache:|^200$"
echo -e "\033[32m"Hit from cloudfront, 200이 출력되는지 확인합니다."\033[0m"
sleep 30
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/static/testobject-cdn.txt | grep -iE "x-cache:|^200$"
echo -e "\n"

echo -e "\033[32m"---------- 8\-3 ----------"\033[0m"
echo -e "\033[32m"Redirect from cloudfront, 301이 출력되는지 확인합니다."\033[0m"
cat << EOF >> testobject-cdn2.txt
This is testobject for marking that CDN perform.
EOF
aws s3 cp --quiet testobject-cdn2.txt s3://$AP_BUCKET/static/
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" http://${CF_DOMAIN}/static/testobject-cdn2.txt | grep -iE "x-cache:|location:|^301$"
echo -e "\n"

echo -e "\033[32m"---------- 8\-4 ----------"\033[0m"
echo -e "\033[32m"Miss from cloudfront, 200이 출력되는지 확인합니다."\033[0m"
cat << EOF >> testobject-cdn-us.txt
This is testobject for marking that CDN perform in US-EAST-1 bucket.
EOF
cat << EOF >> testobject-cdn-ap.txt
This is testobject for marking that CDN perform in AP-NORTHEAST-2 bucket.
EOF
aws s3 cp --quiet testobject-cdn-ap.txt s3://$AP_BUCKET/static/
aws s3 cp --quiet testobject-cdn-us.txt s3://$US_BUCKET/static/
sleep 60
aws s3 rm --quiet s3://$AP_BUCKET/static/testobject-cdn-us.txt
aws s3 rm --quiet s3://$US_BUCKET/static/testobject-cdn-ap.txt
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/static/testobject-cdn-ap.txt | grep -iE "x-cache:|^200$"
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/static/testobject-cdn-us.txt | grep -iE "x-cache:|^200$"
echo -e "\n"

echo -e "\033[32m"---------- 9\-1 ----------"\033[0m"
echo -e "\033[32m"1이 출력되는지 확인합니다."\033[0m"
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress > /dev/null 2>&1; curl --silent -i -X POST --max-time 5 -w "\n%{http_code}\n" -H "Content-Type: application/json" -d '{"iterator":1}' https://${CF_DOMAIN}/v1/stress > /dev/null 2>&1
sleep 60
QUERY_ID=$(aws logs start-query --log-group-name /wsi/webapp/stress --start-time $(date -d '3 minute ago' "+%s") --end-time $(date "+%s") 
--query-string 'fields @message' | jq -r '.queryId')
sleep 5
aws logs get-query-results --query-id $QUERY_ID --query "results[].value" | grep "GET /v1/stress" | wc -l 
aws logs get-query-results --query-id $QUERY_ID --query "results[].value" | grep "POST /v1/stress" | wc -l
echo -e "\n"

echo -e "\033[32m"---------- 9\-2 ----------"\033[0m"
echo -e "\033[32m"1이 출력되는지 확인합니다."\033[0m"
curl --silent -i -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/product > /dev/null 2>&1
sleep 60
QUERY_ID=$(aws logs start-query --log-group-name /wsi/webapp/product --start-time $(date -d '3 minute ago' "+%s") --end-time $(date "+%s") --query-string 'fields @message | limit 20' | jq -r '.queryId')
sleep 5
aws logs get-query-results --query-id $QUERY_ID --query "results[].value" | grep "GET /v1/product" | wc -l
echo -e "\n"

echo -e "\033[32m"---------- 9\-3 ----------"\033[0m"
echo -e "\033[32m"0이 출력되는지 확인합니다."\033[0m"
QUERY_ID=$(aws logs start-query --log-group-name /wsi/webapp/stress --start-time $(date -d '24 hours ago' "+%s") --end-time $(date "+%s") --query-string 'fields @message | limit 20' | jq -r '.queryId')
sleep 5
aws logs get-query-results --query-id $QUERY_ID --query "results[].value" | grep "GET /healthcheck" | wc -l
QUERY_ID=$(aws logs start-query --log-group-name /wsi/webapp/product --start-time $(date -d '24 hours ago' "+%s") --end-time $(date "+%s") --query-string 'fields @message | limit 20' | jq -r '.queryId')
sleep 5
aws logs get-query-results --query-id $QUERY_ID --query "results[].value" | grep "GET /healthcheck" | wc -l
echo -e "\n"

echo -e "\033[32m"---------- 10\-1 ----------"\033[0m"
echo -e "\033[32m"(수동채점) 2가 출력되는지 확인합니다."\033[0m"
aws ecs describe-services --cluster wsi-ecs-cluster --services stress --query "services[0].deployments[0].desiredCount"
echo -e "\033[32m"(수동채점) 5가 출력되는지 확인합니다."\033[0m"
# for i in $(seq 1000000)
# do
#    curl --silent -i -X POST --max-time 5 -w "\n%{http_code}\n" -H 
# "Content-Type: application/json" -d '{"iterator":99999999999}' 
# https://${CF_DOMAIN}/v1/stress > /dev/null 2>&1
# done
# aws ecs describe-services --cluster wsi-ecs-cluster --services stress —query "services[0].deployments[0].desiredCount“
echo -e "\n"

echo -e "\033[32m"---------- 11\-1 ----------"\033[0m"
echo -e "\033[32m"version:v1.1, 200이 출력되는지 확인합니다."\033[0m"
/home/ec2-user/push.sh "deploy new version binary without vulnerability"
curl --silent -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress
echo -e "\n"

echo -e "\033[32m"---------- 11\-2 ----------"\033[0m"
echo -e "\033[32m"version:v1.1, 200이 출력되는지 확인합니다."\033[0m"
cd /home/ec2-user/stress
/home/ec2-user/push.sh "deploy new version binary with vulnerability"
curl --silent -X GET --max-time 5 -w "\n%{http_code}\n" https://${CF_DOMAIN}/v1/stress
echo -e "\n"