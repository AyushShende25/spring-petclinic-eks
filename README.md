# Spring PetClinic on AWS EKS

A production-style deployment of the Spring PetClinic application on Amazon EKS demonstrating containerization, Kubernetes orchestration, persistent storage, ingress, TLS, DNS automation, autoscaling, workload isolation, and security best practices.

---

<img width="991" height="601" alt="spring-petclinic drawio (1)" src="https://github.com/user-attachments/assets/a52c3cc5-473a-4569-81b3-71e6557ad7ec" />

## Features

### Application

* Spring Boot PetClinic application
* Dockerized deployment
* Docker compose for local env.
* Multi-replica deployment on EKS
* Health checks using Spring Boot Actuator

### Kubernetes

* Deployment for application workload
* StatefulSet for MySQL
* ConfigMaps and Secrets
* Resource requests and limits
* Liveness, Readiness, and Startup probes
* Horizontal Pod Autoscaler (HPA)
* Private docker-hub repo

### Networking

* AWS Load Balancer Controller
* ALB Ingress
* Route53 DNS integration
* ExternalDNS automation
* ACM-managed TLS certificates

### Storage

* MySQL persistent storage
* Amazon EBS CSI Driver
* Persistent Volume Claims
* Storage Classes

### Security

* Non-root containers
* Dropped Linux capabilities
* Read-only root filesystem
* Kubernetes Network Policies
* IRSA (IAM Roles for Service Accounts)

### High Availability

* Multi-AZ EKS node group
* Pod topology spread constraints
* Rolling deployments
* Persistent database storage

---

## Repository Structure

```text
k8s/
├── app
│   ├── cm.yaml
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── network-policy.yaml
│   ├── secrets.yaml
│   └── service.yaml
├── cluster.yaml
├── db
│   ├── cm.yaml
│   ├── network-policy.yaml
│   ├── secrets.yaml
│   ├── service.yaml
│   ├── statefulset.yaml
│   └── storageclass.yaml
├── eks-cluster.yaml
├── external-dns-policy.json
├── external-dns-values.yaml
├── iam_policy.json
├── ingress
│   └── ingress.yaml
└── namespaces
    ├── app.yaml
    └── db.yaml
```

---

## Deployment Flow

### 1. Create EKS Cluster

```bash
eksctl create cluster -f eks-cluster.yaml
```

### 2. Install AWS Load Balancer Controller

```bash
helm install aws-load-balancer-controller ...
```

### 3. Install ExternalDNS

```bash
helm install external-dns ...
```

### 4. Deploy Database

```bash
kubectl apply -f k8s/db/
```

### 5. Deploy Application

```bash
kubectl apply -f k8s/app/
```

### 6. Deploy Ingress

```bash
kubectl apply -f k8s/ingress/
```

---

## Accessing the Application

Once deployed:

```text
https://petclinic.fullstackprojects.dev
```

---

## Security Measures Implemented

### Private Registry

* Image stored in private docker-hub repo
* Service Account with secrets for imagePullSecrets

### Container Security

```yaml
runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
```

### IAM

* IRSA for AWS Load Balancer Controller
* IRSA for ExternalDNS

### Networking

* Namespace isolation
* Pod-level access control
* Database access restricted via Network Policies

---

## Technologies Used

| Category         | Technology                   |
| ---------------- | ---------------------------- |
| Application      | Spring Boot                  |
| Containerization | Docker                       |
| Orchestration    | Kubernetes                   |
| Cluster          | Amazon EKS                   |
| Database         | MySQL                        |
| Storage          | Amazon EBS                   |
| Ingress          | AWS Load Balancer Controller |
| DNS              | Route53                      |
| DNS Automation   | ExternalDNS                  |
| TLS              | AWS Certificate Manager      |
| Autoscaling      | HPA                          |
| Networking       | AWS VPC CNI Network Policies |

---

## Future Improvements

* ECR instead of DockerHub
* GitHub Actions CI pipeline
* Terraform infrastructure provisioning
* ArgoCD GitOps deployment
* Prometheus and Grafana monitoring
* Centralized logging
* External Secrets Operator

---

<img width="1440" height="900" alt="Screenshot 2026-06-25 at 1 50 56 AM" src="https://github.com/user-attachments/assets/9d42e9a6-ab33-438d-ab44-46ca260595fb" />
<img width="1440" height="900" alt="Screenshot 2026-06-25 at 2 12 55 AM" src="https://github.com/user-attachments/assets/1fcd125c-76ee-4e1e-975b-8422d1c203e5" />
<img width="1440" height="900" alt="Screenshot 2026-06-25 at 2 14 53 AM" src="https://github.com/user-attachments/assets/9c55f0ec-2d67-475c-951e-523c67843eb0" />

