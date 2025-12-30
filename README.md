# expense-tracker-infra

Terraform-only repository:
- VPC, EKS, IAM
- S3 backend for remote state
- Cluster add-ons installed via Terraform + Helm:
  - Ingress controller
  - ArgoCD
  - Prometheus/Grafana
  - Logging (CloudWatch or ELK)
