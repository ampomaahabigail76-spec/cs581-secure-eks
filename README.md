# CS581 Signature Project â€” Secure Cloud-Native Application on AWS EKS

**Student:** Abigail Ampomaah | **Course:** CS581 â€“ Cloud Security | **Institution:** San Francisco Bay University | **Semester:** Spring 2026

---

## Project Status â€” All 9 Phases Complete

| Phase | Description | Status |
|---|---|---|
| P1 | Infrastructure as Code (Terraform) | Complete |
| P2 | Application Deployment | Complete |
| P3 | Identity and Access Management (IAM + IRSA + RBAC) | Complete |
| P4 | Network Security (Zero-Trust NetworkPolicies) | Complete |
| P5 | Data Security and Encryption | Complete |
| P6 | Container Security (Trivy + PSA + seccomp) | Complete |
| P7 | Monitoring and Observability (GuardDuty + CloudTrail + SNS) | Complete |
| P8 | Threat Simulation (3/3 scenarios validated) | Complete |
| P9 | Documentation | Complete |

---

## Live AWS Environment

| Resource | Value |
|---|---|
| AWS Account | 552823820626 |
| EKS Cluster | cs581-secure-cluster |
| Region | us-east-1 |
| Kubernetes Version | v1.30.14-eks-4136f65 |
| Node | ip-10-0-4-66.ec2.internal |
| Frontend Pod | frontend-6579fc4d8d-gm4sb - Running, 0 restarts |
| Backend Pod | backend-76d97696fd-ckt9m - Running, 0 restarts |
| LoadBalancer | a326f0bd98e774f2f8da07d641cb544f-492495057.us-east-1.elb.amazonaws.com |
| GuardDuty Detector | f0cf0254fe2e09f6c53af60b11b1b116 |
| Secret ARN | arn:aws:secretsmanager:us-east-1:552823820626:secret:cs581/db-password-J5I75H |
| IAM Policy | arn:aws:iam::552823820626:policy/BackendSecretsPolicy |

---

## Security Controls Implemented

### Identity and Access Management
- BackendSecretsPolicy: secretsmanager:GetSecretValue + kms:Decrypt on 1 key, region-locked to us-east-1
- IRSA: Scoped to ONE pod: system:serviceaccount:fintech-app:app-backend
- RBAC: app-reader role, read-only verbs only, no destructive actions

### Network Security Zero-Trust
- default-deny-all: Blocks ALL ingress and egress by default
- allow-frontend-ingress: Internet to frontend port 80 via ALB only
- allow-frontend-to-backend: frontend to backend port 3000 only
- allow-egress-dns: UDP 53 for DNS resolution

### Data Security Encryption Everywhere

| Layer | Encryption |
|---|---|
| Secrets at rest | AWS KMS AES-256 envelope encryption |
| EKS etcd | encryptionConfig active verified via aws eks describe-cluster |
| EBS volumes | AWS-managed encryption on all worker node volumes |
| In transit user | ALB TLS 1.3 with ACM certificate |
| In transit control plane | mTLS between EKS control plane and worker nodes |
| AWS API calls | HTTPS + SigV4 request signing |
| Pod-to-pod | AWS Nitro System hypervisor encryption |
| KMS rotation | Automatic annual rotation |
| IRSA tokens | 1-hour TTL, no long-lived access keys |

### Container Security
- Trivy scans: nginx:alpine = 0 CVEs, python:3.11-slim = 10 HIGH CVEs documented
- runAsNonRoot: true on all containers
- readOnlyRootFilesystem: true
- allowPrivilegeEscalation: false
- capabilities.drop: ALL
- seccompProfile: RuntimeDefault
- No latest tags, immutable pinned references

### Monitoring and Observability

| Source | Coverage |
|---|---|
| Amazon GuardDuty | EKS Audit Log Monitoring + EKS Protection enabled |
| Amazon CloudWatch | 835MB ingested, 18575 records, 24 log streams |
| AWS CloudTrail | Every AWS API call across the account |
| VPC Flow Logs | Packet metadata for network forensics |
| Container Insights | Per-pod CPU, memory, restarts, stdout/stderr |
| CloudWatch SNS | 3 alarms: GuardDuty HIGH/MED, Node CPU over 80%, Failed auth over 10 in 5min |

---

## Threat Simulation Results 3 of 3 Validated

| Scenario | Detection | Result |
|---|---|---|
| AWS root credentials used GetFindingsStatistics | GuardDuty Policy:IAMUser/RootCredentialUsage | Detected in under 2 minutes |
| Privileged container breakout attempt | PSA admission webhook blocked | 1659 CrashLoopBackOff restarts neutralized |
| Compromised viewer role kubectl delete deployment | 403 Forbidden captured in EKS audit log | RBAC blocked SNS alarm triggered |

---

## Repository Structure

- terraform/ - VPC, EKS cluster, IAM roles, KMS, encryptionConfig
- k8s/ - Deployments, Services, RBAC, NetworkPolicies
- docs/ - Technical Report, Presentation, Architecture Diagram
- .gitignore
- README.md

---

## Tools and Versions

| Tool | Version | Purpose |
|---|---|---|
| Terraform | v1.14.8 | Infrastructure as Code |
| eksctl | v0.225.0 | EKS management |
| kubectl | v1.35.3 | Kubernetes CLI |
| Helm | v4.1.3 | Package management |
| Trivy | v0.69.3 | Container vulnerability scanning |
| AWS CLI | v2.34.29 | AWS API access |

---

## Quick Verification Commands

kubectl get nodes
kubectl get pods -n fintech-app
kubectl get services -n fintech-app
kubectl get networkpolicies -n fintech-app
kubectl get roles,rolebindings -n fintech-app
kubectl get secrets -n fintech-app

---

## Deliverables

| Deliverable | Location | Status |
|---|---|---|
| Technical Report | docs/CS581_Technical_Report.docx | Complete |
| Architecture Diagram | docs/architecture-diagram.png | Complete |
| Presentation 15 slides | docs/CS581_Final_Presentation.pptx | Complete |
| GitHub Repository | This repo | Complete |
| Demo Video | Zoom recording 15 minutes | Complete |

---

Abigail Ampomaah - CS581 Cloud Security - San Francisco Bay University - Spring 2026