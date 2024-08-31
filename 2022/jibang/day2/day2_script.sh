#!/bin/bash

# Region : us-east-1

echo -e "\033[32m"---------- 1 ----------"\033[0m"
echo -e "\033[32m"Kinesis Data Analytics 생성을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 2 ----------"\033[0m"
echo -e "\033[32m"생성된 S3 Bucket을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 3 ----------"\033[0m"
echo -e "\033[32m"생성된 IAM Role을 확인합니다."\033[0m"
echo -e "\033[32m"생성된 IAM Policy 내 S3 Bucket 접근 권한을 확인합니다."\033[0m"
echo -e "\033[32m"생성된 IAM Policy 내 Kinesis 접근 권한을 확인합니다."\033[0m"
echo -e "\033[32m"생성된 IAM Policy 내 CloudWatch Logs 접근 권한을 확인합니다."\033[0m"
echo -e "\033[32m"생성된 IAM Policy 내 CloudWatch 접근 권한을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 4 ----------"\033[0m"
echo -e "\033[32m"Kinesis Data Stream 생성을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 5 ----------"\033[0m"
echo -e "\033[32m"Kinesis Data Analytics 내 Bucket 설정을 확인합니다."\033[0m"
echo -e "\033[32m"Kinesis Data Analytics 내 객체 설정 \/kda_flink_jar\/kinesis-data-analytics-flink.jar을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 6 ----------"\033[0m"
echo -e "\033[32m"Group ID : FlinkAppProperties 설정을 확인합니다."\033[0m"
echo -e "\033[32m"Key : s3_output_path 설정을 확인합니다."\033[0m"
echo -e "\033[32m"Value : s3a:\/\/BUCKET_NAME\/kda_flink_starter_kit_output 설정을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 7 ----------"\033[0m"
echo -e "\033[32m"Kinesis Data Analytics Application 상태 Running을 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 8 ----------"\033[0m"
echo -e "\033[32m"CloudWatch Logs에 새로운 로그가 쌓이는지 확인합니다."\033[0m"
echo -e "\n"

echo -e "\033[32m"---------- 9 ----------"\033[0m"
echo -e "\033[32m"Kinesis Data Stream으로 데이터를 전송하고 S3에 저장되는지 확인합니다."\033[0m"
echo -e "\n"