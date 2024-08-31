#!/bin/bash

# Region : us-east-1

echo -e "\033[32m"---------- 1 ----------"\033[0m"
echo -e "\033[32m"Service_A에 접속하여 status code 200 OK를 확인합니다."\033[0m"
curl -i service.internal
echo -e "\n"

echo -e "\033[32m"---------- 2 ----------"\033[0m"
echo -e "\033[32m"VPC_A와 10.2.0.0/16를 확인합니다."\033[0m"
echo -e "\033[32m"VPC_B와 10.4.0.0/16를 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3 ----------"\033[0m"
echo -e "\033[32m"10.2.0.0/24, 10.2.1.0/24를 확인합니다."\033[0m"
echo -e "\033[32m"10.4.0.0/24, 10.4.1.0/24, 10.4.2.0/24를 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4 ----------"\033[0m"
echo -e "\033[32m"Service_A 인스턴스는 VPC_A의 private subnet에 생성됐는지 확인합니다."\033[0m"
echo -e "\033[32m"Service_B 인스턴스는 VPC_B의 private subnet에 생성됐는지 확인합니다."\033[0m"
echo -e "\033[32m"Bastion_A, Bastion_B 인스턴스는 public ip가 할당되었는지 확인합니다."\033[0m"
echo -e "\033[32m"인스턴스의 이미지는 Amazon Linux인지 확인합니다."\033[0m"
echo -e "\033[32m"인스턴스의 타입은 t3.micro인지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 5 ----------"\033[0m"
echo -e "\033[32m"로드밸런서 1개가 존재하는지 확인합니다."\033[0m"
echo -e "\033[32m"대상그룹 1개가 존재하는지 확인합니다."\033[0m"
echo -e "\033[32m"대상그룹 정상 1, port 80 세부정보를 확인합니다."\033[0m"
echo -e "\033[32m"등록된 인스턴스가 Service_B인지 확인합니다."\033[0m"
echo -e "\033[32m"등록된 인스턴스의 상태가 health인지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 6 ----------"\033[0m"
echo -e "\033[32m"수동 채점"\033[0m"
echo -e "\033[32m"Bastion_B를 통해 Service_B에 접속하여 80 listening 중인지 확인합니다."\033[0m"
# netstat -ntl
echo -e "\033[32m"Bastion_B를 통해 Service_B에 접속하여 status code 200 ok를 확인합니다."\033[0m"
# curl -i localhost
echo -e "\n"

echo -e "\033[32m"---------- 7 ----------"\033[0m"
echo -e "\033[32m"피어링 연결 상태를 확인합니다."\033[0m"
echo -e "\033[32m"요청자 VPC가 VPC_A이고, 수락자 VPC가 VPC_B인지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 8 ----------"\033[0m"
echo -e "\033[32m"private subnet A 라우팅 테이블 0.0.0.0/0 NAT gateway 연결을 확인합니다."\033[0m"
echo -e "\033[32m"private subnet A 라우팅 테이블 10.4.0.0/16 peering 연결을 확인합니다."\033[0m"
echo -e "\033[32m"private subnet B 라우팅 테이블 0.0.0.0/0 NAT gateway 연결을 확인합니다."\033[0m"
echo -e "\033[32m"private subnet B 라우팅 테이블 10.2.0.0/16 peering 연결을 확인합니다."\033[0m"
echo -e "\033[32m"public subnet A 라우팅 테이블 0.0.0.0/0 Internet gateway 연결을 확인합니다."\033[0m"
echo -e "\033[32m"public subnet B 라우팅 테이블 0.0.0.0/0 Internet gateway 연결을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 9 ----------"\033[0m"
echo -e "\033[32m"NAT gateway가 public subnet A에 생성됐는지 확인합니다."\033[0m"
echo -e "\033[32m"NAT gateway가 public subnet B에 생성됐는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 10 ----------"\033[0m"
echo -e "\033[32m"VPC_A에 연결된 인터넷 게이트웨이를 확인합니다."\033[0m"
echo -e "\033[32m"VPC_B에 연결된 인터넷 게이트웨이를 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 11 ----------"\033[0m"
echo -e "\033[32m"Bastion_A 보안그룹 인바운드 0.0.0.0/0 22인지 확인합니다."\033[0m"
echo -e "\033[32m"Bastion_A 보안그룹 아웃바운드 10.0.0.0/8 또는 10.2.0.0/16인지 확인합니다."\033[0m"
echo -e "\033[32m"Bastion_B 보안그룹 인바운드 0.0.0.0/0 22인지 확인합니다."\033[0m"
echo -e "\033[32m"Bastion_B 보안그룹 아웃바운드 10.0.0.0/8 또는 10.2.0.0/16인지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 12 ----------"\033[0m"
echo -e "\033[32m"Service_A 보안그룹 인바운드 source가 Bastion_A 보안그룹인지 확인합니다."\033[0m"
echo -e "\033[32m"Service_A 보안그룹 아웃바운드 80, 443인지 확인합니다."\033[0m"
echo -e "\033[32m"Service_B 보안그룹 인바운드 22 source가 Bastion_A 보안그룹인지 확인합니다."\033[0m"
echo -e "\033[32m"Service_B 보안그룹 인바운드 80 source가 ELB 보안그룹인지 확인합니다."\033[0m"
echo -e "\033[32m"Service_B 보안그룹 아웃바운드 80, 443인지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 13 ----------"\033[0m"
echo -e "\033[32m"로드밸런서 보안그룹 인바운드 10.0.0.0/8 80을 확인합니다."\033[0m"
echo -e "\033[32m"로드밸런서 보안그룹 아웃바운드 10.0.0.0/8 80을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 14 ----------"\033[0m"
echo -e "\033[32m"internal 호스팅 영역을 확인합니다."\033[0m"
echo -e "\033[32m"프라이빗 호스팅 영역 유형을 확인합니다."\033[0m"
echo -e "\033[32m"VPC_A의 연결을 확인합니다."\033[0m"
echo -e "\033[32m"service.internal에 ELB가 연결되었는지 확인합니다."\033[0m"
echo -e "\033[32m"VPC_B DNS Host 이름 설정이 활성화되었는지 확인합니다."\033[0m"
echo -e "\n"