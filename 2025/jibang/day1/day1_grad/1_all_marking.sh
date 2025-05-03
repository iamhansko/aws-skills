#!/bin/bash

#######
# 1-1 #
#######
aws ec2 describe-vpcs --filter Name=tag:Name,Values=ws-vpc --query "Vpcs[].CidrBlock"


#######
# 1-2 #
#######
aws ec2 describe-route-tables --filter Name=tag:Name,Values=ws-priv-rt-a --query "RouteTables[].Routes[].NatGatewayId"


#######
# 1-3 #
#######
aws ec2 describe-route-tables --filter Name=tag:Name,Values=ws-priv-rt-c --query "RouteTables[].Routes[].NatGatewayId"


#######
# 1-4 #
#######
aws ec2 describe-route-tables --filter Name=tag:Name,Values=ws-pub-rt --query "RouteTables[].Routes[].GatewayId"


#######
# 1-5 #
#######
aws ec2 describe-subnets --filter Name=tag:Name,Values=ws-priv-a --query "Subnets[].AvailabilityZone"


#######
# 1-6 #
#######
aws ec2 describe-subnets --filter Name=tag:Name,Values=ws-pub-c --query "Subnets[].AvailabilityZone"


#######
# 1-7 #
#######
aws elbv2 describe-load-balancers --query "LoadBalancers[?LoadBalancerName==gateway-alb-pub'].AvailabilityZones[].ZoneName"


#######
# 2-1 #
#######
aws ecs describe-clusters --cluster ws-cluster --query "clusters[].clusterName"


#######
# 2-2 #
#######
aws ecs describe-task-definition --task-definition gateway-td --query "taskDefinition.containerDefinitions[].name"


#######
# 2-3 #
#######
aws ecs describe-task-definition --task-definition product-td --query "taskDefinition.containerDefinitions[].name"


#######
# 2-4 #
#######
aws ecs describe-services --cluster ws-cluster --services gateway-svc --query "services[].status"


#######
# 2-5 #
#######
 aws ecs describe-services --cluster ws-cluster --services product-svc --query "services[].status"


#######
# 2-6 #
#######
aws ecs describe-task-definition --task-definition gateway-td --query "taskDefinition.containerDefinitions[].image"


#######
# 2-7 #
#######
aws ecs describe-task-definition --task-definition product-td --query "taskDefinition.containerDefinitions[].image"


#######
# 2-8 #
#######
aws ecr describe-image-scan-findings --repository-name gateway --image-id imageTag=v1.0.0 --query "imageScanFindings.findingSeverityCounts" 


#######
# 2-9 #
#######
aws ecr describe-image-scan-findings --repository-name product --image-id imageTag=v1.0.0 --query "imageScanFindings.findingSeverityCounts"


########
# 2-10 #
########
aws ecs describe-clusters --cluster wsi-ecs --query "clusters[].runningTasksCount"


########
# 2-11 #
########
aws ecs describe-services --cluster ws-cluster --services gateway-svc --query "services[].networkConfiguration.awsvpcConfiguration[].subnets[]"


########
# 2-12 #
########
aws ecs describe-services --cluster ws-cluster --services product-svc --query "services[].networkConfiguration.awsvpcConfiguration[].subnets[]"


########
# 2-13 #
########
export | grep -i CONN_PRODUCT


########
# 2-14 #
########
curl --silent http://product/health


#######
# 3-1 #
#######
aws dynamodb describe-table --table-name "product" --query "Table.TableStatus"


#######
# 3-2 #
#######
aws dynamodb describe-table --table-name "product" --query "Table.BillingModeSummary.BillingMode"


#######
# 3-3 #
#######
aws dynamodb describe-table --table-name "product" --query "Table.DeletionProtectionEnabled"


#######
# 3-4 #
#######
aws dynamodb list-backups --table-name product


#######
# 3-5 #
#######
aws dynamodb describe-table --table-name product --query "Table.SSEDescription.KMSMasterKeyArn"


#######
# 3-6 #
#######
echo "Manual marking"


#######
# 3-7 #
#######
echo "Manual marking"


#############
# 4-1 ~ 4-7 #
#############
echo "Manual marking"