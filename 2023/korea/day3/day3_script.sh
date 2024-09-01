#!/bin/bash

echo -e "\033[33mCloudFront Distribution ID를 입력하세요.\033[0m"
read DistributionID

echo -e "\033[32m"---------- 1\-1 ----------"\033[0m"
echo -e "\033[32m"ECR에 접근하여 foo 이름을 가진 repository가 존재하는지, scan-on-=push 기능이 활성화되었는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 1\-2 ----------"\033[0m"
echo -e "\033[32m"컨테이너 이미지를 업로드합니다."\033[0m"
# cd /home/ec2-user/container
# ./build.sh
echo -e "\n"

echo -e "\033[32m"---------- 1\-3 ----------"\033[0m"
echo -e "\033[32m"컨테이너를 실행합니다."\033[0m"
# docker run -d -p 8080:8080 foo:<time>
# curl -X GET -w "\n%{http_code}\n" http://localhost:8080/v1/foo
echo -e "\n"

echo -e "\033[32m"---------- 1\-4 ----------"\033[0m"
echo -e "\033[32m"ECR에 접근하여 foo 이름을 가진 repository에 현재 시간대의 태그를 가진 이미지가 취약점이 0개임을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 2\-1 ----------"\033[0m"
echo -e "\033[32m"S3에 접근하여 2개의 S3 버킷이 생성된 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 2\-2 ----------"\033[0m"
echo -e "\033[32m"wsi-day3-private-xxxx 버킷에서 employee024.csv 파일을 다운로드 받습니다. birthday, name, licensenumber, gender, epid 컬럼이 존재하는 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 2\-3 ----------"\033[0m"
echo -e "\033[32m"Macie에 접근하여 하나 이상의 Job이 실행된 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 2\-4 ----------"\033[0m"
echo -e "\033[32m"wsi-day3-public-xxxx 버킷에서 employee024.csv 파일을 다운로드 받습니다. birthday, name, gender 컬럼만 존재하는 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3\-1 ----------"\033[0m"
echo -e "\033[32m"red-user 사용자로 정상적으로 로그인되는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3\-2 ----------"\033[0m"
echo -e "\033[32m"ec2에 접근하여 wsi-bastion 인스턴스 리스트, 타입이 보이는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3\-3 ----------"\033[0m"
echo -e "\033[32m"임의의 ec2 인스턴스 생성을 시도합니다. key=project,value=blue 태그를 설정합니다. 인스턴스가 생성되지 않고 에러가 발생하는 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3\-4 ----------"\033[0m"
echo -e "\033[32m"임의의 ec2 인스턴스 생성을 시도합니다. key=project,value=red 태그를 설정합니다. 인스턴스가 정상적으로 생성되어야 합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4\-1 ----------"\033[0m"
echo -e "\033[32m"Cloudformation에 접근하여 day3-wsi-s3-bucket-stack 스택의 상태가 CREATE_COMPLETE 또는 UPDATED_COMPLETE 상태임을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4\-2 ----------"\033[0m"
echo -e "\033[32m"S3에 접근하여 S3 버킷을 확인합니다. day3-wsi-temp-bucket-xxxx"\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4\-3 ----------"\033[0m"
echo -e "\033[32m"S3에 접근하여 Default encryption 항목의 Encryption Type이 SSE-KMS로 설정된 것을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4\-4 ----------"\033[0m"
echo -e "\033[32m"KMS에 접근하여 Customer managed key를 확인합니다. day3-wsi-temp-bucket-xxxx Alias를 가진 CMK가 있음을 확인합니다."\033[0m"
echo -e "\n"