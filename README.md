# CS581 Signature Project - Secure Cloud-Native Application on AWS EKS
## Project Overview
Deployed a secure multi-tier fintech application on Amazon EKS following cloud security best practices across 9 phases.
**AWS Account:** 552823820626
**Cluster:** cs581-secure-cluster (us-east-1)
**Kubernetes Version:** 1.30
## Architecture
- VPC with public/private subnets (10.0.0.0/16)
- EKS worker nodes in private subnets only
- Internet Gateway + NAT Gateway + AWS Load Balancer in public subnets
- KMS encryption, CloudWatch logging, AWS Secrets Manager
## Security Controls
| Phase | Control | Status |
|-------|---------|--------|
| Phase 1 | Secure VPC Architecture | Done |
| Phase 2 | EKS Cluster with KMS + CloudWatch | Done |
| Phase 3 | Frontend + Backend deployment | Done |
| Phase 4 | IAM least privilege + Kubernetes RBAC | Done |
| Phase 5 | Network Policies default-deny | Done |
| Phase 6 | Secrets Manager + EBS encryption | Done |
| Phase 7 | Trivy image scanning + non-root containers | Done |
| Phase 8 | CloudWatch logging + GuardDuty configured | Done |
| Phase 9 | Threat simulation - 2 scenarios blocked | Done |
## Repository Structure
- terraform/ - All Terraform IaC files
- k8s/ - Kubernetes manifests
- docs/ - Technical report, presentation, architecture diagram
## Threat Simulations
1. Unauthorized token access - Blocked immediately
2. Privileged container escalation - CrashLoopBackOff
## Tools Used
Terraform v1.14.8, kubectl v1.35.3, eksctl v0.225.0, Helm v4.1.3, Trivy, AWS CLI v2.34.29
