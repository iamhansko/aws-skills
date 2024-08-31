# 2022 Jibang Day 2

## How to Test
```bash
# 1. Create a Stack using day2_iac.yaml
# 2. Upload kinesis-data-analytics-flink.jar -> YOUR_S3_BUCKET("/kda_flink_jar/")

# 3. Kinesis Data Analytics Configuration -> Application code location
Amazon S3 Bucket : YOUR_S3_BUCKET
Path to S3 object : /kda_flink_jar/kinesis-data-analytics-flink.jar

# 4. Run Kinesis Data Analytics Application
# 5. Upload day2_grad_flink_test.zip -> YOUR_S3_BUCKET("/")

# 6. Instnce Connect - Bastion Ec2
sudo dnf update -y
sudo dnf install -y java
aws s3 cp s3://YOUR_S3_BUCKET_NAME/day2_grad_flink_test.zip ./
unzip day2_grad_flink_test.zip
mv flink_test/* ~

aws dynamodb create-table \
--cli-input-json file://kda-flink-benchmarking-utility/create_table_kinesis_stream.json \
--region us-east-1 \
--endpoint-url http://localhost:8000

aws dynamodb create-table \
--cli-input-json file://kda-flink-benchmarking-utility/create_table_parent_job_summary.json \
--region us-east-1 \
--endpoint-url http://localhost:8000

aws dynamodb create-table \
--cli-input-json file://kda-flink-benchmarking-utility/create_table_child_job_summary.json \
--region us-east-1 \
--endpoint-url http://localhost:8000

chmod +x script.sh
./script.sh

# 7. Check your S3 Bucket in 5~10 minutes
```