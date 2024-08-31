#!/bin/bash

aws ec2 describe-vpcs --filter Name=tag:Name,Values=skills-vpc --query "Vpcs[].CidrBlock"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=skills-private-b-rt --query "RouteTables[].Routes[].NatGatewayId"

kubectl -n skills get pods | grep match | head -n 1
# kubectl exec -n skills -it match-xx12345688-xxx111 -- sh -c "curl http://localhost:8080/v1/match?token=cccccccc"
# kubectl exec -n skills -it match-xx12345688-xxx111 -- sh -c "curl http://localhost:8080/v1/match?token=11131111"

kubectl -n skills get pods | grep stress | head -n 1
# kubectl exec -n skills -it stress-xx12345688-xxx111 -- sh -c "curl http://localhost:8080/v1/stress"
# kubectl exec -n skills -it stress-xx12345688-xxx111 -- sh -c "curl http://localhost:8080/v1/random"
# kubectl exec -n skills -it stress-xx12345688-xxx111 -- sh -c "whoami"

aws ecr describe-repositories --repository-name match-ecr --query "repositories[].repositoryName"
aws ecr list-images --repository-name stress-ecr --query "imageIds[].imageTag"

aws eks describe-cluster --name skills-cluster --query "cluster.version"
aws eks describe-cluster --name skills-cluster --query "cluster.logging.clusterLogging"
aws eks describe-nodegroup --cluster-name skills-cluster --nodegroup-name skills-app --query "nodegroup.instanceTypes"
aws eks describe-nodegroup --cluster-name skills-cluster --nodegroup-name skills-addon --query "nodegroup.subnets"

sed -i 's/skills\/version: v1/skills\/version: v101/g' /home/ec2-user/deployment.yaml
kubectl apply -n skills -f deployment.yaml
kubectl describe -n skills deployment match | grep NewReplicaSet | grep match
# kubectl get pods -n skills | grep match-xxxxyyyyzz
# kubectl get pods | grep match-xxxxyyyyzz
# kubectl get pods -n skills match-xxxxyyyyzz-pppzz -o yaml | grep v101

# kubectl scale -n skills deployment stress --replicas=0
# sleep 15
# kubectl scale -n skills deployment stress --replicas=2
# cat stress_result_XXXXXX.txt | grep –v 200

kubectl -n skills get pods | grep match
# kubectl -n skills exec -it match-xxxxxxxxx-aaaaa -- sh -c "curl http://www.naver.com"
# kubectl -n skills exec -it match-xxxxxxxxx-aaaaa -- sh
# echo $STRESS_SERVICE_HOST
# curl http://${STRESS_SERVICE_HOST}:${STRESS_SERVICE_PORT}/v1/stress
kubectl -n skills get pods | grep stress
# kubectl -n skills exec -it stress-xxxxxxxxx-aaaaa sh -c "curl http://www.naver.com"
# kubectl -n skills exec -it stress-xxxxxxxxx-aaaaa sh
# echo $MATCH_SERVICE_HOST
# curl http://${MATCH_SERVICE_HOST}:${MATCH_SERVICE_PORT}/v1/match?token=aa
kubectl -n skills get ingress | grep -v stress
curl --silent -o /dev/null -w %{http_code} http://ALB_INGRESS_DOMAIN/health
curl --silent -o /dev/null -w %{http_code} http://ALB_INGRESS_DOMAIN/v1/match?token=aa
kubectl -n skills get ingress | grep -v match
curl --silent -o /dev/null -w %{http_code} http://ALB_INGRESS_DOMAIN/health
curl --silent -o /dev/null -w %{http_code} http://ALB_INGRESS_DOMAIN/v1/stress

kubectl get pods -n skills -o wide
kubectl get nodes ip-10-0-1-129.ap-northeast-2.compute.internal -o json | jq ".metadata.labels"

 kubectl get pods -n kube-system -o wide | grep cluster-autoscaler
 kubectl get nodes ip-10-x-x-x.ap-northeast-2.compute.internal -o json | jq ".metadata.labels"

kubectl get nodes
git clone https://codeberg.org/hjacobs/kube-ops-view.git
cd kube-ops-view/
kubectl apply -k deploy
kubectl patch svc kube-ops-view -p "{\"spec\": {\"type\": \"LoadBalancer\"}}"
kubectl run load-generator1 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator2 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator3 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator4 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator5 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator6 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator7 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator8 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator9 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run load-generator10 --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/stress; done" 
kubectl run -i load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://stress.skills.svc.cluster.local/v1/random; done"