#!/bin/bash

# Pre task
aws configure set region ap-northeast-2

cd /home/ec2-user/korea/
terraform init && terraform destroy -auto-approve && terraform apply -auto-approve

# 3-1
echo --------------------
echo "       3-1        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].InstanceId --output text


# 3-2
echo --------------------
echo "       3-2        "
echo --------------------

aws ec2 describe-vpcs --filters Name=tag:Name,Values=[korea-vpc] --query Vpcs[].CidrBlock

# 3-3
echo --------------------
echo "       3-3        "
echo --------------------

aws ec2 describe-subnets --filters Name=tag:Name,Values=[korea-public-subnet-a] --query Subnets[].AvailabilityZone


# 3-4
echo --------------------
echo "       3-4        "
echo --------------------

VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=[korea-vpc] --query Vpcs[].VpcId --output text)
aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=[$VPC_ID] --query InternetGateways[].InternetGatewayId


# 3-5
echo --------------------
echo "       3-5        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].InstanceType


# 3-6
echo --------------------
echo "       3-6        "
echo --------------------

SUBNET_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].SubnetId)
aws ec2 describe-subnets --subnet-ids $SUBNET_ID --query Subnets[].Tags[?Key==\`Name\`].Value


# 3-7
echo --------------------
echo "       3-7        "
echo --------------------

VOLUME_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId --output text)
aws ec2 describe-volumes --volume-ids $VOLUME_ID --query Volumes[].Encrypted


# 3-8
echo --------------------
echo "       3-8        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].IamInstanceProfile | grep -i Arn


# 3-9
echo --------------------
echo "       3-9        "
echo --------------------
INSTANCE_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=[korea-instance] --query Reservations[].Instances[].InstanceId --output text)
aws ssm describe-instance-information --filters Key=InstanceIds,Values=[$INSTANCE_ID] --query InstanceInformationList[].PingStatus
