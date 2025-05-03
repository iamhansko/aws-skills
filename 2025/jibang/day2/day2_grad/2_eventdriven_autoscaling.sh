#!/bin/bash

# Pre task
aws configure set region ap-northeast-2

# 2-1
echo --------------------
echo "       2-1        "
echo --------------------
aws eks describe-cluster --name order-cluster --query cluster.version


# 2-2
echo --------------------
echo "       2-2        "
echo --------------------

aws eks update-kubeconfig --name order-cluster
kubectl get deployment --namespace order | grep order-processor


# 2-3
echo --------------------
echo "       2-3        "
echo --------------------

kubectl get po -n order | grep order-processor 


# 2-4
echo --------------------
echo "       2-4        "
echo --------------------

kubectl describe deployment -n order | grep -E "QUEUE_URL|REGION_NAME"


# 2-5
echo --------------------
echo "       2-5        "
echo --------------------

QUEUE_URL=$(aws sqs get-queue-url --queue-name order-queue --query QueueUrl --output text)
echo $QUEUE_URL


# 2-6
echo --------------------
echo "       2-6        "
echo --------------------

kubectl get po -A | grep keda-operator


# 2-7
echo --------------------
echo "       2-7        "
echo --------------------

kubectl get scaledobjects.keda.sh -A

# 2-8, 2-9
echo --------------------
echo " 2-8, 2-9 Manual marking "
echo --------------------