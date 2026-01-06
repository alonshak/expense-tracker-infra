# Expense Tracker – Infrastructure (EKS Platform)

This repository contains the cloud infrastructure and Kubernetes platform
for the Expense Tracker project, implemented using Terraform and Amazon EKS.

The focus of this repository is platform engineering:
networking, cluster provisioning, compute, and core Kubernetes capabilities.

Application code, deployments, and GitOps configuration are managed in separate repositories.

---

## 🎯 Repository Purpose

The purpose of this repository is to:

- Provision AWS infrastructure in a reproducible way
- Build a production-aligned Kubernetes platform
- Validate each infrastructure layer independently
- Maintain strict cost awareness and clean Git workflows

This is not a demo repository — every component is added intentionally
and verified before moving forward.

---

## 🏗️ What This Repository Manages

- AWS networking (VPC, subnets, routing)
- Amazon EKS cluster provisioning
- Kubernetes worker nodes (Managed Node Groups)
- Core cluster-level capabilities required for production readiness

---

## 📂 Repository Structure

expense-tracker-infra/
├── environments/
│   ├── staging/
│   └── production/
├── modules/
│   ├── vpc/
│   └── eks/
├── helm-addons/
└── README.md

---

## �� Implemented Infrastructure (Current State)

### Networking Layer

- Custom VPC
- Public and private subnets
- Internet Gateway
- Single NAT Gateway (low-cost design)
- Route tables and subnet associations

---

### Kubernetes Control Plane

- Amazon EKS cluster
- IAM roles and permissions
- Networking integration with the VPC

---

### Compute Layer

- EKS Managed Node Group
- Worker nodes running in private subnets
- Minimal node count for cost efficiency
- Automatic IAM configuration for nodes

---

### Cluster Add-ons

- Kubernetes Metrics Server installed in the kube-system namespace
- Metrics API enabled (metrics.k8s.io)
- Resource visibility enabled via kubectl

Validation commands:

kubectl get deployment metrics-server -n kube-system
kubectl top nodes
kubectl top pods -A

---

## 🔄 Workflow & Validation Model

All infrastructure changes follow a strict workflow:

terraform apply
→ verify (AWS Console / kubectl)
→ commit
→ pull request
→ merge

Earlier stages were validated using ephemeral environments
(apply → verify → destroy) to minimize cloud costs.

At the current stage, the cluster may remain running temporarily
to support platform-level components.

---

## 📌 Scope Clarification

This repository intentionally focuses only on infrastructure
and Kubernetes platform concerns.

It does not include:

- Application code
- CI/CD pipelines
- GitOps configuration
- Business logic or frontend assets

Those concerns are handled in their respective repositories.

---

## 👤 Author Notes

This infrastructure was built with a production mindset,
prioritizing clarity, correctness, and real-world DevOps workflows
over shortcuts or one-off configurations.
