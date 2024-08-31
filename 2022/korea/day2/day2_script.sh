#!/bin/bash

echo -e "\033[32m"---------- 1\-1 ----------"\033[0m"
echo -e "\033[32m"10.10.0.0/16이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-vpcs --filter Name=tag:Name,Values=skills-vpc --query "Vpcs[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-2 ----------"\033[0m"
echo -e "\033[32m"10.10.0.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-3 ----------"\033[0m"
echo -e "\033[32m"10.10.1.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-b --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-4 ----------"\033[0m"
echo -e "\033[32m"10.10.2.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-c --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-5 ----------"\033[0m"
echo -e "\033[32m"10.10.10.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-pub-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-6 ----------"\033[0m"
echo -e "\033[32m"10.10.11.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-pub-b --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-7 ----------"\033[0m"
echo -e "\033[32m"10.10.12.0/24가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-pub-c --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"---------- 1\-8 ----------"\033[0m"
echo -e "\033[32m"ap-northeast-2a가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-a --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"---------- 1\-9 ----------"\033[0m"
echo -e "\033[32m"ap-northeast-2b가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-b --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"---------- 1\-10 ----------"\033[0m"
echo -e "\033[32m"ap-northeast-2c가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-priv-c --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"---------- 1\-11 ----------"\033[0m"
echo -e "\033[32m"igw-로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=skills-pub-rt --query "RouteTables[].Routes[].GatewayId"
echo -e "\n"

echo -e "\033[32m"---------- 1\-12 ----------"\033[0m"
echo -e "\033[32m"nat-로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=skills-priv-a-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"---------- 1\-13 ----------"\033[0m"
echo -e "\033[32m"nat-로 시작하는 문구가 출력되는지 확인합니다. \(1-12와 다른 값이어야 합니다.\)"\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=skills-priv-b-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"---------- 1\-14 ----------"\033[0m"
echo -e "\033[32m"nat-로 시작하는 문구가 출력되는지 확인합니다. \(1-12, 1-13과 다른 값이어야 합니다.\)"\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=skills-priv-c-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"---------- 2\-1 ----------"\033[0m"
echo -e "\033[32m"skills-commit이 출력되는지 확인합니다."\033[0m"
aws codecommit list-repositories
echo -e "\n"

echo -e "\033[32m"---------- 2\-2 ----------"\033[0m"
echo -e "\033[32m"upstream이 출력되는지 확인합니다."\033[0m"
aws codecommit get-branch --repository-name skills-commit --branch-name upstream --query branch.branchName
echo -e "\n"

echo -e "\033[32m"---------- 3\-1 ----------"\033[0m"
echo -e "\033[32m"skills-build가 출력되는지 확인합니다."\033[0m"
aws codebuild list-projects --query projects
echo -e "\n"

echo -e "\033[32m"---------- 4\-1 ----------"\033[0m"
echo -e "\033[32m"ECS가 출력되는지 확인합니다."\033[0m"
aws deploy get-application --application-name skills-app --query application.computePlatform
echo -e "\n"

echo -e "\033[32m"---------- 4\-2 ----------"\033[0m"
echo -e "\033[32m"BLUE\/GREEN이 출력되는지 확인합니다."\033[0m"
aws deploy get-deployment-group --application-name skills-app --deployment-group-name skills-dg --query deploymentGroupInfo.deploymentStyle.deploymentType
echo -e "\n"

echo -e "\033[32m"---------- 4\-3 ----------"\033[0m"
echo -e "\033[32m"'clusterName':'skills-cluster', 'serviceName':'skills-svc'가 출력되는지 확인합니다."\033[0m"
aws deploy get-deployment-group --application-name skills-app --deployment-group-name skills-dg --query deploymentGroupInfo.ecsServices
echo -e "\n"

echo -e "\033[32m"---------- 4\-4 ----------"\033[0m"
echo -e "\033[32m"'name':'skills-tg1', 'name':'skills-tg2'가 출력되는지 확인합니다."\033[0m"
aws deploy get-deployment-group --application-name skills-app --deployment-group-name skills-dg --query "deploymentGroupInfo.loadBalancerInfo.targetGroupPairInfoList[].targetGroups[]"
echo -e "\n"

echo -e "\033[32m"---------- 5\-1 ----------"\033[0m"
echo -e "\033[32m"skills-commit이 출력되는지 확인합니다."\033[0m"
aws codepipeline get-pipeline --name skills-pipeline --query "pipeline.stages[0].actions[].configuration.RepositoryName"
echo -e "\n"

echo -e "\033[32m"---------- 5\-2 ----------"\033[0m"
echo -e "\033[32m"skills-build가 출력되는지 확인합니다."\033[0m"
aws codepipeline get-pipeline --name skills-pipeline --query "pipeline.stages[1].actions[].configuration.ProjectName"
echo -e "\n"

echo -e "\033[32m"---------- 5\-3 ----------"\033[0m"
echo -e "\033[32m"skills-app이 출력되는지 확인합니다."\033[0m"
aws codepipeline get-pipeline --name skills-pipeline --query "pipeline.stages[2].actions[].configuration.ApplicationName"
echo -e "\033[32m"skills-dg가 출력되는지 확인합니다."\033[0m"
aws codepipeline get-pipeline --name skills-pipeline --query "pipeline.stages[2].actions[].configuration.DeploymentGroupName"
echo -e "\n"

echo -e "\033[32m"---------- 6\-1 ----------"\033[0m"
echo -e "\033[32m"true가 출력되는지 확인합니다."\033[0m"
aws route53 list-hosted-zones --query 'HostedZones[?Name == `skills.local.`].Config.PrivateZone'
echo -e "\n"

echo -e "\033[32m"---------- 6\-2 ----------"\033[0m"
echo -e "\033[32m"IP를 정상적으로 출력하는지 확인합니다."\033[0m"
nslookup app.skills.local
echo -e "\n"

echo -e "\033[32m"---------- 7\-1 ----------"\033[0m"
echo -e "\033[32m"application이 출력되는지 확인합니다."\033[0m"
aws elbv2 describe-load-balancers --query 'LoadBalancers[?LoadBalancerName == `skills-alb`].Type'
echo -e "\n"

echo -e "\033[32m"---------- 7\-2 ----------"\033[0m"
echo -e "\033[32m""ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"가 출력되는지 확인합니다."\033[0m"
aws elbv2 describe-load-balancers --query 'LoadBalancers[?LoadBalancerName == `skills-alb`].AvailabilityZones[].ZoneName'
echo -e "\n"

echo -e "\033[32m"---------- 8\-1 ----------"\033[0m"
echo -e "\033[32m"BLUE가 출력되는지 확인합니다."\033[0m"
curl http://app.skills.local/v1/dummy
echo -e "\n"

echo -e "\033[32m"---------- 9\-1 ----------"\033[0m"
echo -e "\033[32m"skills-commit 내 main.go 13번째 줄 BLUE를 GREEN으로 수정합니다."\033[0m"
echo -e "\033[32m"skills-pipeline의 Source, Build, Deploy 상태가 모두 Succeeded로 바뀌는지 확인합니다. \(최대 7분 소요\)"\033[0m"
echo -e "\033[32m"skills-pipeline의 Deploy Traffic shifting progress에서 Replacement가 100%인지 확인합니다."\033[0m"
echo -e "\033[33m"확인이 정상적으로 끝났다면 Enter를 입력해주세요."\033[0m"
read pipeline_check
echo -e "\n"

echo -e "\033[32m"---------- 9\-2 ----------"\033[0m"
echo -e "\033[32m"\(수동채점\)"\033[0m"
echo -e "\033[32m"skills-ecr 내 한국시간 기준 년-월-일.시.분.초 형식으로 최근에 업로드된 이미지가 있는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 9\-3 ----------"\033[0m"
echo -e "\033[32m"GREEN이 출력되는지 확인합니다."\033[0m"
curl http://app.skills.local/v1/dummy
echo -e "\n"

echo -e "\033[32m"---------- 9\-4 ----------"\033[0m"
echo -e "\033[32m"skills-commit 내 main.go 13번째 줄 GREEN을 RED로, 19번째 줄 :80을 :88로 수정합니다."\033[0m"
echo -e "\033[32m"skills-pipeline의 Source, Build, Deploy 상태가 Succeeded로 바뀌고, Deploy Install Event가 계속 In progress인지 확인합니다. \(최대 5분 소요\)"\033[0m"
echo -e "\033[33m"확인이 정상적으로 끝났다면 Enter를 입력해주세요."\033[0m"
read pipeline_check
echo -e "\n"

echo -e "\033[32m"---------- 9\-5 ----------"\033[0m"
echo -e "\033[32m"GREEN이 출력되는지 확인합니다."\033[0m"
curl http://app.skills.local/v1/dummy
echo -e "\n"

echo -e "\033[32m"---------- 10\-1 ----------"\033[0m"
echo -e "\033[32m"i\-로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filter Name=tag:Name,Values=skills-bastion2 --query 'Reservations[].Instances[].InstanceId'
echo -e "\n"

echo -e "\033[32m"---------- 10\-2 ----------"\033[0m"
echo -e "\033[32m"동일한 IP가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filter Name=tag:Name,Values=skills-bastion2 --query "Reservations[].Instances[].PublicIpAddress"
aws ec2 describe-addresses --query "Addresses[].PublicIp"
echo -e "\n"