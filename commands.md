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

kubectl apply -f k8s/db/secrets.yaml
kubectl get secrets -n pet-clinic-db
kubectl apply -f k8s/db/cm.yaml
kubectl apply -f k8s/db/service.yaml
kubectl apply -f k8s/db/statefulset.yaml
kubectl get all -n pet-clinic-db
kubectl logs mysql-0 -n pet-clinic-db

kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<username> \
  --docker-password=<dockerhub-pat> \
  --docker-email=<email> \
  -n pet-clinic-app
kubectl delete secret dockerhub-secret -n pet-clinic-app
kubectl get secrets -n pet-clinic-app

kubectl apply -f k8s/app/deployment.yaml
kubectl delete -f k8s/app/deployment.yaml
kubectl rollout restart deployment petclinic-app -n pet-clinic-app
kubectl get pods -n pet-clinic-app -w
kubectl describe pods -n pet-clinic-app
kubectl logs petclinic-app-56dbc4d9c6-s6wgx -n pet-clinic-app

kubectl create sa dockerhub-sa -n pet-clinic-app
kubectl get sa dockerhub-sa -n pet-clinic-app -o yaml
kubectl edit sa dockerhub-sa -n pet-clinic-app
