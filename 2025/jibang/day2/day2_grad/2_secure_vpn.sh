#!/bin/bash

# Pre task
aws configure set region ap-northeast-2

# 1-1
echo --------------------
echo "       1-1        "
echo --------------------

export VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=[ws-vpn-vpc] --query Vpcs[].VpcId --output text)
aws ec2 describe-vpcs --filters Name=tag:Name,Values=[ws-vpn-vpc] --query Vpcs[].CidrBlock

# 1-2
echo --------------------
echo "       1-2        "
echo --------------------

aws ec2 describe-subnets --filters Name=tag:Name,Values=[ws-public-subnet-a] --query Subnets[].CidrBlock

# 1-3
echo --------------------
echo "       1-3        "
echo --------------------

aws ec2 describe-subnets --filters Name=tag:Name,Values=[ws-private-subnet-b] --query Subnets[].CidrBlock

# 1-4
echo --------------------
echo "       1-4        "
echo --------------------
export PUBLIC_SUBNET_IDS=$(aws ec2 describe-nat-gateways --filter Name=state,Values=[available] --query NatGateways[].SubnetId --output text)
aws ec2 describe-subnets --subnet-ids $PUBLIC_SUBNET_IDS --query Subnets[].AvailabilityZone

# 1-5
echo --------------------
echo "       1-5        "
echo --------------------

export CVPN_ID=$(aws ec2 describe-client-vpn-endpoints  --filters Name=tag:Name,Values=[ws-client-vpn] --query ClientVpnEndpoints[].ClientVpnEndpointId --output text)
aws ec2 describe-client-vpn-endpoints --client-vpn-endpoint-id $CVPN_ID --query ClientVpnEndpoints[].ClientCidrBlock

# 1-6
echo --------------------
echo "       1-6        "
echo --------------------

aws ec2 describe-client-vpn-target-networks --client-vpn-endpoint-id $CVPN_ID --query ClientVpnTargetNetworks[].TargetNetworkId --output text
aws ec2 describe-instances --filters Name=tag:Name,Values=[ws-web-a,ws-web-b] --query Reservations[].Instances[].SubnetId --output text

# 1-7
echo --------------------
echo "       1-7        "
echo --------------------

aws ec2 describe-client-vpn-authorization-rules --client-vpn-endpoint-id $CVPN_ID --query AuthorizationRules[].DestinationCidr


# 1-8
echo --------------------
echo "       1-8        "
echo --------------------
echo Manual marking

# 1-9
echo --------------------
echo "       1-9        "
echo --------------------

aws ec2 describe-instances --filters Name=tag:Name,Values=[ws-web-a,ws-web-b] --query Reservations[].Instances[].PrivateIpAddress --output text
echo "Please memorize the 2 IPs before connecting to VPN
