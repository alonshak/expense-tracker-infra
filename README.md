# Expense Tracker – Infrastructure (EKS Platform)

This repository contains the **cloud infrastructure and Kubernetes platform**
for the Expense Tracker project, implemented using **Terraform** and **Amazon EKS**.

The focus of this repository is **platform engineering**:
networking, cluster provisioning, compute, and validation of core Kubernetes
capabilities required for production environments.

Application code, GitOps configuration, and CI/CD pipelines
are managed in separate repositories.

---

## 🎯 Repository Purpose

The purpose of this repository is to:

- Provision AWS infrastructure in a reproducible way
- Build a production-aligned Kubernetes platform
- Validate platform capabilities incrementally
- Separate **infrastructure state** from **runtime validation**
- Maintain strict cost awareness and clean Git workflows

This repository intentionally distinguishes between:
- **Declarative infrastructure (Terraform-managed)**
- **Operational platform validation (runtime-only components)**

---

## 🏗️ What This Repository Manages

- AWS networking (VPC, subnets, routing)
- Amazon EKS cluster provisioning
- Kubernetes worker nodes (Managed Node Groups)
- Validation of essential Kubernetes platform capabilities

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
├── tmp/
│   └── ingress-test/
└── README.md

---

## 🧱 Implemented Infrastructure (Current State)

### 1️⃣ Networking Layer (Declarative)

- Custom VPC
- Public and private subnets
- Internet Gateway
- Single NAT Gateway (low-cost design)
- Route tables and subnet associations

Managed via Terraform and fully reproducible.

---

### 2️⃣ Kubernetes Control Plane (Declarative)

- Amazon EKS cluster
- IAM roles and permissions
- Networking integration with the VPC

Managed via Terraform and fully reproducible.

---

### 3️⃣ Compute Layer – Managed Node Groups (Declarative)

- EKS Managed Node Group
- Worker nodes running in private subnets
- Minimal node count for cost efficiency
- Automatic IAM configuration for nodes

Managed via Terraform and fully reproducible.

---

### 4️⃣ Cluster Metrics Capability (Validation Milestone)

- Kubernetes Metrics Server installed at runtime
- Metrics API (`metrics.k8s.io`) enabled
- Cluster resource visibility validated using:
  - `kubectl top nodes`
  - `kubectl top pods -A`

This milestone validates that the cluster can observe
real-time CPU and memory usage.

> This component is intentionally **not yet managed by IaC or GitOps**
> and is expected to be ephemeral at this stage.

---

### 5️⃣ External Traffic Ingress Capability (Validation Milestone)

- NGINX Ingress Controller installed at runtime
- AWS Network Load Balancer (NLB) provisioned automatically
- External HTTP traffic successfully routed into the cluster
- Ingress rules validated using a dummy nginx service

Traffic flow validated:

Internet  
→ AWS NLB  
→ NGINX Ingress Controller  
→ Kubernetes Service  
→ Pod

> This milestone validates external connectivity and request routing.
> Ingress components are currently runtime-only and not yet codified.

---

## 🔄 Workflow & Validation Model

Infrastructure changes follow a strict workflow:

terraform apply  
→ verify (AWS Console / kubectl)  
→ commit → pull request → merge  

Early milestones focus on **declarative infrastructure**.
Later milestones introduce **operational validation** before
locking components into GitOps and Helm.

This approach prevents premature codification
and ensures platform understanding before automation.

---

## 📌 Scope Clarification

This repository focuses on **infrastructure provisioning and platform validation**.

It intentionally does **not** include:
- Application manifests
- CI/CD pipelines
- GitOps application definitions
- Business logic or frontend code

Those concerns are handled in their respective repositories.

---

## 👤 Author Notes

This infrastructure was built with a **production mindset**,
prioritizing clarity, correctness, and platform understanding
over one-off demos or irreversible early decisions.

Validation milestones intentionally precede GitOps adoption
to ensure architectural correctness before automation.
