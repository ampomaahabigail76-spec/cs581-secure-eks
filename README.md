\# CS581 Signature Project — Secure Cloud-Native Application on AWS EKS



> \*\*Design, Implementation, and Security Hardening of a Multi-Tier Fintech Application\*\*



\*\*Student:\*\* Abigail Ampomaah | \*\*Course:\*\* CS581 – Cloud Security | \*\*Institution:\*\* San Francisco Bay University | \*\*Semester:\*\* Spring 2026



\---



\## 🏆 Project Status — All 9 Phases Complete



| Phase | Description | Status |

|---|---|---|

| P1 | Infrastructure as Code (Terraform) | ✅ Complete |

| P2 | Application Deployment | ✅ Complete |

| P3 | Identity \& Access Management (IAM + IRSA + RBAC) | ✅ Complete |

| P4 | Network Security (Zero-Trust NetworkPolicies) | ✅ Complete |

| P5 | Data Security \& Encryption | ✅ Complete |

| P6 | Container Security (Trivy + PSA + seccomp) | ✅ Complete |

| P7 | Monitoring \& Observability (GuardDuty + CloudTrail + SNS) | ✅ Complete |

| P8 | Threat Simulation (3/3 scenarios validated) | ✅ Complete |

| P9 | Documentation | ✅ Complete |



\---



\## ☁️ Live AWS Environment



| Resource | Value |

|---|---|

| AWS Account | 552823820626 |

| EKS Cluster | cs581-secure-cluster |

| Region | us-east-1 |

| Kubernetes Version | v1.30.14-eks-ecaa3a6 |

| Node | ip-10-0-4-165.ec2.internal (Ready) |

| Frontend Pod | frontend-58cff846f4-bgkzc — Running, 0 restarts, 20d |

| Backend Pod | backend-857c445f5b-9kpk2 — Running, 0 restarts, 20d |

| LoadBalancer URL | a5b76c047d478437d974e755103e0ac8-1159874357.us-east-1.elb.amazonaws.com |

| GuardDuty Detector | f0cf0254fe2e09f6c53af60b11b1b116 |

| Secret ARN | arn:aws:secretsmanager:us-east-1:552823820626:secret:cs581/db-password-J5I75H |

| IAM Policy | arn:aws:iam::552823820626:policy/BackendSecretsPolicy |



\---



\## 🔐 Security Controls Implemented



\### Identity \& Access Management

\- \*\*BackendSecretsPolicy\*\* — Customer managed, least-privilege: `secretsmanager:GetSecretValue` + `kms:Decrypt` on 1 key, region-locked to us-east-1

\- \*\*IRSA\*\* — Scoped to ONE pod: `system:serviceaccount:fintech-app:app-backend`

\- \*\*RBAC\*\* — `app-reader` role: read-only verbs only, no destructive actions



\### Network Security (Zero-Trust)

```

default-deny-all          → Blocks ALL ingress/egress by default

allow-frontend-ingress    → Internet → frontend:80 via ALB only

allow-frontend-to-backend → frontend → backend:3000 only

allow-egress-dns          → UDP 53 for DNS resolution

```



\### Data Security — Encryption Everywhere

| Layer | Encryption |

|---|---|

| Secrets at rest | AWS KMS AES-256 envelope encryption |

| EKS etcd | encryptionConfig active (verified via aws eks describe-cluster) |

| EBS volumes | AWS-managed encryption on all worker node volumes |

| In transit (user) | ALB TLS 1.3 with ACM certificate |

| In transit (control plane) | mTLS between EKS control plane and worker nodes |

| AWS API calls | HTTPS + SigV4 request signing |

| Pod-to-pod | AWS Nitro System hypervisor encryption |

| KMS rotation | Automatic annual rotation |

| IRSA tokens | 1-hour TTL — no long-lived access keys |



\### Container Security

\- \*\*Trivy scans\*\*: nginx:alpine → 0 CVEs ✅ | python:3.11-slim → 10 HIGH CVEs documented

\- `runAsNonRoot: true` — all containers

\- `readOnlyRootFilesystem: true`

\- `allowPrivilegeEscalation: false`

\- `capabilities.drop: \[ALL]` — no Linux capabilities

\- `seccompProfile: RuntimeDefault`

\- No `:latest` tags — immutable pinned references



\### Monitoring \& Observability

| Source | Coverage |

|---|---|

| Amazon GuardDuty | EKS Audit Log Monitoring + EKS Protection enabled |

| Amazon CloudWatch | 835MB ingested · 18,575 records · 24 log streams |

| AWS CloudTrail | Every AWS API call across the account |

| VPC Flow Logs | Packet metadata for network forensics |

| Container Insights | Per-pod CPU, memory, restarts, stdout/stderr |

| CloudWatch → SNS | 3 alarms: GuardDuty HIGH/MED · Node CPU >80% · Failed auth >10 in 5min |



\---



\## 🎯 Threat Simulation Results — 3/3 Validated



| # | Scenario | Detection | Result |

|---|---|---|---|

| 1 | AWS root credentials used (GetFindingsStatistics) | GuardDuty: Policy:IAMUser/RootCredentialUsage | Detected in < 2 minutes ✅ |

| 2 | Privileged container breakout attempt | PSA admission webhook blocked | 1,659 CrashLoopBackOff restarts — neutralized ✅ |

| 3 | Compromised viewer role: kubectl delete deployment | 403 Forbidden — captured in EKS audit log | RBAC blocked · >10 denials → SNS alarm ✅ |



\---



\## 📁 Repository Structure



```

cs581-secure-eks/

├── terraform/

│   ├── main.tf           # Provider, backend config

│   ├── vpc.tf            # VPC, subnets, NAT gateway, VPC Flow Logs

│   ├── eks.tf            # EKS cluster, node group, encryptionConfig

│   ├── iam.tf            # IAM roles, IRSA, BackendSecretsPolicy

│   ├── variables.tf      # Input variables

│   └── outputs.tf        # Output values (cluster ARN, etc.)

├── k8s/

│   ├── namespace.yaml    # fintech-app namespace with PSA labels

│   ├── frontend.yaml     # Frontend deployment + service

│   ├── backend.yaml      # Backend deployment + service

│   ├── rbac.yaml         # app-reader Role + RoleBinding

│   └── network-policy.yaml  # All 4 NetworkPolicies

├── docs/

│   ├── CS581\_Technical\_Report.docx

│   ├── CS581\_FINAL\_PRESENTATION.pptx

│   └── architecture-diagram.png

├── .gitignore            # Excludes .terraform/, \*.tfstate, .aws/

└── README.md

```



\---



\## 🛠 Tools \& Versions



| Tool | Version | Purpose |

|---|---|---|

| Terraform | v1.14.8 | Infrastructure as Code |

| eksctl | v0.225.0 | EKS management |

| kubectl | v1.35.3 | Kubernetes CLI |

| Helm | v4.1.3 | Package management |

| Trivy | v0.69.3 | Container vulnerability scanning |

| AWS CLI | v2.34.29 | AWS API access |



\---



\## 🚀 Quick Verification Commands



```powershell

\# Verify cluster is running

kubectl get nodes

kubectl get pods -n fintech-app

kubectl get services -n fintech-app



\# Verify all security controls

kubectl get networkpolicies -n fintech-app

kubectl get roles,rolebindings -n fintech-app

kubectl get secrets -n fintech-app



\# Verify encryptionConfig

aws eks describe-cluster --region us-east-1 --name cs581-secure-cluster \\

&#x20; --query 'cluster.{name:name,version:version,encryptionConfig:encryptionConfig}'

```



\---



\## ⚠️ Cleanup (Avoid AWS Charges)



```powershell

\# Delete Kubernetes resources

kubectl delete namespace fintech-app



\# Destroy all Terraform infrastructure

cd terraform/

terraform destroy -auto-approve

```



\---



\## 📋 Deliverables



| Deliverable | Location | Status |

|---|---|---|

| Technical Report | docs/CS581\_Technical\_Report.docx | ✅ |

| Architecture Diagram | docs/architecture-diagram.png | ✅ |

| Presentation (15 slides) | docs/CS581\_FINAL\_PRESENTATION.pptx | ✅ |

| GitHub Repository | This repo | ✅ |

| Demo Video | Zoom recording — 15 minutes | ✅ |



\---



\*Abigail Ampomaah · CS581 Cloud Security · San Francisco Bay University · Spring 2026\*



