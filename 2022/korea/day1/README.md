# 2022 Korea Day1

# Create a EKS Cluster (CloudFormation)

# Bastion EC2
- kubectl
```bash
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/install-kubectl.html
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
exec bash
aws eks update-kubeconfig --region ap-northeast-2 --name skills-cluster
aws eks create-access-entry --cluster-name skills-cluster --principal-arn arn:aws:iam::AWS_ACCOUNT_ID:role/Ec2AdminRole
aws eks associate-access-policy --cluster-name skills-cluster --principal-arn arn:aws:iam::AWS_ACCOUNT_ID:role/Ec2AdminRole --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope type=cluster
aws eks describe-access-entry --cluster-name skills-cluster --principal-arn arn:aws:iam::AWS_ACCOUNT_ID:role/Ec2AdminRole
```
- eksctl
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
# eksctl version
# OIDC Kubernetes ServiceAccount가 IAM Resource에 Access할 때 필요
# aws configure set region ap-northeast-2
oidc_id=$(aws eks describe-cluster --name skills-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
eksctl utils associate-iam-oidc-provider --cluster skills-cluster --approve --region ap-northeast-2
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
```
- AWS Load Balancer Controller
```bash
# Install HELM
sudo dnf install -y git
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/lbc-helm.html
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json
aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://iam_policy.json
eksctl create iamserviceaccount \
--cluster=skills-cluster \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--role-name AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn=arn:aws:iam::AWS_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
--approve --region ap-northeast-2
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=skills-cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=ap-northeast-2 \
--set vpcId=vpc-08b113dc72267bb30
# kubectl get deployment -n kube-system aws-load-balancer-controller
```
- Cluster Autoscaler (CA)
```bash
export CLUSTER_NAME=$(eksctl get clusters -o json | jq -r '.[0].Name')
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=ap-northeast-2
echo $CLUSTER_NAME $ACCOUNT_ID $AWS_REGION
aws autoscaling describe-auto-scaling-groups \
--query "AutoScalingGroups[? Tags[? (Key=='eks:cluster-name') && Value=='${CLUSTER_NAME}']].[AutoScalingGroupName, MinSize, MaxSize,DesiredCapacity]" \
--output table
eksctl utils associate-iam-oidc-provider \
--cluster ${CLUSTER_NAME} \
--approve
mkdir -p ~/environment/cluster-autoscaler
cat <<EoF > ~/environment/cluster-autoscaler/cluster-autoscaler-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/${CLUSTER_NAME}": "owned"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeLaunchTemplateVersions",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "ec2:DescribeInstanceTypes"
            ],
            "Resource": "*"
        }
    ]
}
EoF
aws iam create-policy   \
  --policy-name AmazonEKSClusterAutoscalerPolicy \
  --policy-document file://~/environment/cluster-autoscaler/cluster-autoscaler-policy.json
eksctl create iamserviceaccount \
    --name cluster-autoscaler \
    --namespace kube-system \
    --cluster ${CLUSTER_NAME} \
    --attach-policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/AmazonEKSClusterAutoscalerPolicy" \
    --approve \
    --override-existing-serviceaccounts
kubectl -n kube-system describe sa cluster-autoscaler
curl -o ~/environment/cluster-autoscaler/cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
sed -i 's/<YOUR CLUSTER NAME>/skills-cluster/g' ~/environment/cluster-autoscaler/cluster-autoscaler-autodiscover.yaml
kubectl apply -f ~/environment/cluster-autoscaler/cluster-autoscaler-autodiscover.yaml
kubectl -n kube-system \
    annotate deployment.apps/cluster-autoscaler \
    cluster-autoscaler.kubernetes.io/safe-to-evict="false"
# we need to retrieve the latest docker image available for our EKS version
export K8S_VERSION=$(kubectl version --short | grep 'Server Version:' | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | cut -d. -f1,2)
export AUTOSCALER_VERSION=$(curl -s "https://api.github.com/repos/kubernetes/autoscaler/releases" | grep '"tag_name":' | sed -s 's/.*-\([0-9][0-9\.]*\).*/\1/' | grep -m1 ${K8S_VERSION})
# version 확인
echo $AUTOSCALER_VERSION
kubectl -n kube-system \
    set image deployment.apps/cluster-autoscaler \
    cluster-autoscaler=registry.k8s.io/autoscaling/cluster-autoscaler:v${AUTOSCALER_VERSION}
kubectl -n kube-system logs -f deployment/cluster-autoscaler
```
- Horizontal Pod Autoscaler (HPA)
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get apiservice v1beta1.metrics.k8s.io -o json | jq '.status'
kubectl create deployment php-apache --image=us.gcr.io/k8s-artifacts-prod/hpa-example
kubectl set resources deploy php-apache --requests=cpu=200m
kubectl expose deploy php-apache --port 80
kubectl get pod -l app=php-apache
kubectl autoscale deployment php-apache --cpu-percent=60 --min=1 --max=10
kubectl get hpa
# kube-ops-view
git clone https://codeberg.org/hjacobs/kube-ops-view.git
cd kube-ops-view/
kubectl apply -k deploy
kubectl edit svc kube-ops-view
# serviceType : LoadBalancer
kubectl get svc kube-ops-view | tail -n 1 | awk '{ print "Kube-ops-view URL = http://"$4 }'
# Stress App
kubectl run -i --tty load-generator --image=busybox /bin/sh
while true; do wget -q -O - http://php-apache; done
kubectl get hpa -w
kubectl delete deployment php-apache
kubectl delete hpa php-apache
```

### References
- https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/action-reference-ECSbluegreen.html
- https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/tutorials-ecs-ecr-codedeploy.html
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html
- https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-ECSbluegreen.html#action-reference-ECSbluegreen-type
- https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/tutorials-ecs-ecr-codedeploy.html#tutorials-ecs-ecr-codedeploy-taskdefinition
- https://docs.aws.amazon.com/ko_kr/AmazonCloudFront/latest/DeveloperGuide/restrict-access-to-load-balancer.html
- https://catalog.workshops.aws/eks-autoscaling/ko-KR/03-pod-autoscaling/01-hpa
- https://repost.aws/ko/knowledge-center/eks-troubleshoot-rbac-errors
- https://www.eksworkshop.com/docs/security/cluster-access-management/associating-policies
- https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/troubleshooting.html#unauthorized
- (Deprecated) https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/auth-configmap.html