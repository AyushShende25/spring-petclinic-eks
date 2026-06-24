./mvnw -DskipTests clean package

docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:9.7

java -jar target/spring-petclinic-4.0.0-SNAPSHOT.jar

docker build -t petclinic .

docker run -p 8080:8080 -e SPRING_DATASOURCE_URL=jdbc:mysql://host.docker.internal:3306/petclinic petclinic

docker compose up -d
docker compose down
docker compose logs

docker build -t ayushshende9/pet-clinic:1.0.0 .
docker push ayushshende9/pet-clinic:1.0.0

kind create cluster --config k8s/cluster.yaml --name pet-clinic-kube-cluster

kubectl api-resources

kubectl apply -f k8s/db/secrets.yaml
kubectl get secrets -n pet-clinic-db
kubectl apply -f k8s/db/cm.yaml
kubectl get cm
kubectl apply -f k8s/db/service.yaml
kubectl get svc
kubectl apply -f k8s/db/storageclass.yaml
kubectl get sc
kubectl apply -f k8s/db/statefulset.yaml
kubectl get sts
kubectl get all -n pet-clinic-db
kubectl logs mysql-0 -n pet-clinic-db

kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<username> \
  --docker-password=<dockerhub-pat> \
  --docker-email=<email> \
  -n pet-clinic-app
kubectl delete secret dockerhub-secret -n pet-clinic-app
kubectl apply -f k8s/app/secrets.yaml
kubectl get secrets -n pet-clinic-app
kubectl apply -f k8s/app/cm.yaml
kubectl apply -f k8s/app/service.yaml
kubectl apply -f k8s/app/deployment.yaml
kubectl delete -f k8s/app/deployment.yaml
kubectl rollout restart deployment petclinic-app -n pet-clinic-app
kubectl get pods -n pet-clinic-app -w
kubectl describe pods -n pet-clinic-app
kubectl logs petclinic-app-56dbc4d9c6-s6wgx -n pet-clinic-app

kubectl create sa dockerhub-sa -n pet-clinic-app
kubectl get sa dockerhub-sa -n pet-clinic-app -o yaml
kubectl edit sa dockerhub-sa -n pet-clinic-app

eksctl create cluster -f k8s/eks-cluster.yaml
kubectl get nodes --show-labels
kubectl config set-context --current --namespace=pet-clinic-db

kubectl port-forward svc/petclinic-svc 8080:8080

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.14.1/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
    --cluster=petclinic \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region ap-south-1 \
    --approve

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=petclinic \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0
  
kubectl get deployment -n kube-system aws-load-balancer-controller

aws eks describe-cluster --name petclinic \
  --query "cluster.identity.oidc.issuer" --output text

aws iam create-policy --policy-name "AllowExternalDNSUpdates" --policy-document file://external-dns-policy.json
aws iam list-policies
eksctl create iamserviceaccount \
  --cluster petclinic \
  --name "external-dns" \
  --namespace external-dns \
  --attach-policy-arn arn:aws:iam::<aws-ccount-id>:policy/AllowExternalDNSUpdates \
  --approve

helm repo add --force-update external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update
helm install external-dns external-dns/external-dns \
  -n external-dns \
  -f external-dns-values.yaml
kubectl get pods -n external-dns -l app.kubernetes.io/name=external-dns
