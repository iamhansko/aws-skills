#!/bin/bash

# Pre task
aws configure set region ap-northeast-1


# 4-1
echo --------------------
echo "       4-1        "
echo --------------------

aws ec2 run-instances --image-id "ami-03f584e50b2d32776" --instance-type "t3.micro" --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"instance-1-2025x2gj"},{"Key":"Project","Value":"skills2022"}]}' --count "1" --no-cli-pager > /dev/null
aws ec2 run-instances --image-id "ami-03f584e50b2d32776" --instance-type "t3.micro" --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"instance-2-2025x2gj"},{"Key":"Project","Value":"skills2022"}]}' --count "1" --no-cli-pager > /dev/null
aws ec2 run-instances --image-id "ami-03f584e50b2d32776" --instance-type "t3.micro" --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"instance-3-2025x2gj"},{"Key":"Project","Value":"skills2023"}]}' --count "1" --no-cli-pager > /dev/null
aws ec2 run-instances --image-id "ami-03f584e50b2d32776" --instance-type "t3.micro" --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"instance-4-2025x2gj"},{"Key":"Project","Value":"skills2024"}]}' --count "1" --no-cli-pager > /dev/null

sleep 30


# 4-2
echo --------------------
echo "       4-2        "
echo --------------------

cd /home/ec2-user/ec2-automation/

ls -l | grep delete_old_instance

chmod +x delete_old_instance.sh
./delete_old_instance.sh

sleep 30


# 4-3
echo --------------------
echo "       4-3        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-1-2025x2gj] --query Reservations[].Instances[].State


# 4-4
echo --------------------
echo "       4-4        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-2-2025x2gj] --query Reservations[].Instances[].State


# 4-5
echo --------------------
echo "       4-5        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-3-2025x2gj] --query Reservations[].Instances[].State
aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-4-2025x2gj] --query Reservations[].Instances[].State


# 4-6
echo --------------------
echo "       4-6        "
echo --------------------

cd /home/ec2-user/ec2-automation/

ls -l | grep delete_all_instance

chmod +x delete_all_instance.sh
./delete_all_instance.sh

sleep 30

# 4-7
echo --------------------
echo "       4-7        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-3-2025x2gj] --query Reservations[].Instances[].State


# 4-8
echo --------------------
echo "       4-8       "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[instance-4-2025x2gj] --query Reservations[].Instances[].State


# 4-9
echo --------------------
echo "       4-9        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[automation-bastion] --query Reservations[].Instances[].State
