#!/bin/bash

echo -e "\033[32m"---------- 1-1 ----------"\033[0m"
echo -e "\033[32m"실행되는 docker의 PORTS 부분이 80 -> 8080을 포함하는지 확인합니다."\033[0m"
docker ps
echo -e "\033[32m"\{'status':'ok'\}를 출력하는지 확인합니다."\033[0m"
curl http://localhost:80/health
echo -e "\n"

echo -e "\033[32m"---------- 2-1 ----------"\033[0m"
/opt/cli.sh
echo -e "\033[32m"/opt/cli.sh가 실행되었습니다. 출력되는 Bucket Name을 입력해주세요. \(s3://skills-korea-2022-...\)"\033[0m"
echo -e "\033[32m"Bucket Name : "\033[0m"
read bucket_name
echo -e "\033[32m"a.txt, b.txt, c.txt 파일이 업로드되었는지 확인합니다. 날짜가 현재시간이어야 합니다."\033[0m"
aws s3 ls $bucket_name
echo -e "\n"

echo -e "\033[32m"---------- 3-1 ----------"\033[0m"
echo -e "\033[32m"수동 채점"\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4-1 ----------"\033[0m"
echo -e "\033[32m"cloudformation이 포함된 문구가 출력되지 않는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:NAme,Values=skills-22-q4-priv-B --query "Subnets[].Tags[]"
echo -e "\033[32m"리소스를 생성합니다. 완료되면 Successfully created/updated stack 문구가 출력되며 최대 10분 정도 소요됩니다."\033[0m"
aws cloudformation deploy --template-file '/opt/cf.yaml' --stack-name vpc-q4
echo -e "\033[32m"Key : aws:cloudformation:stack-id가 포함된 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=skills-22-q4-priv-B --query "Subnets[].Tags[]"
echo -e "\n"