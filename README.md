# Expense Tracker – Infrastructure Platform

Production-grade cloud infrastructure and Kubernetes platform for the **Expense Tracker** application.

This repository defines the **AWS infrastructure and EKS-based Kubernetes platform** using Terraform, following real-world DevOps practices such as milestone-based delivery, Git workflows, cost awareness, and reproducibility.

---

## 🚀 Project Overview

The goal of this project is to design and build a **production-ready Kubernetes platform** that can reliably run a real application, while maintaining:

- Clear separation of concerns
- Minimal and controlled cloud costs
- Git-based workflows
- Full infrastructure reproducibility

This repository focuses **only on infrastructure and platform concerns**.  
Application code and deployments are handled in separate repositories.

---

## ��️ Architecture Summary

- **Cloud Provider:** AWS  
- **Infrastructure as Code:** Terraform  
- **Networking:** Custom VPC (public + private subnets, NAT Gateway)  
- **Kubernetes:** Amazon EKS  
- **Compute:** EKS Managed Node Groups  
- **Deployment Model:** GitOps (via ArgoCD in later stages)

> Terraform provisions the cloud and cluster infrastructure.  
> Kubernetes manages runtime, workloads, networking, and scaling.

---

## 📂 Repository Structure

```text
expense-tracker-infra/
├── environments/
│   ├── staging/
│   └── production/
├── modules/
│   ├── vpc/
│   └── eks/
├── helm-addons/
└── README.md
```

**Key concepts:**
- `modules/` – reusable Terraform building blocks  
- `environments/` – environment-specific wiring and configuration  
- `helm-addons/` – cluster-level services added incrementally  

---

## 🧱 Infrastructure Milestones

The platform was built incrementally using **clear milestones**, each validated independently before moving forward.

---

### ✅ Milestone 1 – VPC Networking

**Implemented:**
- Custom VPC
- Public and private subnets
- Internet Gateway
- Single NAT Gateway (low-cost design)
- Route tables and associations

**Purpose:**  
Establish a secure and production-ready network foundation.

---

### ✅ Milestone 2 – EKS Control Plane

**Implemented:**
- Amazon EKS control plane
- IAM roles and permissions
- Cluster networking integration

**Intentionally excluded:**
- Worker nodes
- Add-ons
- Workloads

**Purpose:**  
Validate Kubernetes control plane, IAM, and networking in isolation.

---

### ✅ Milestone 3 – Managed Node Groups

**Implemented:**
- EKS Managed Node Group
- Private subnet placement
- Minimal node count for cost efficiency
- Automatic IAM configuration

**Verification:**
```bash
kubectl get nodes
kubectl get namespaces
```

**Purpose:**  
Introduce compute capacity and allow workloads to run on the cluster.

---

## 🔄 Workflow & Cost Strategy

Infrastructure changes follow a consistent and disciplined workflow:

```text
terraform apply
→ verify (AWS / kubectl)
→ commit → PR → merge
```

Early milestones used **ephemeral environments** (`apply → destroy`) to reduce costs.  
Later milestones operate on a **persistent cluster** to support platform-level components.

---

## 🚫 Out of Scope (By Design)

The following were intentionally excluded to keep the project focused:

- Multi-region deployments
- Service mesh
- Advanced autoscaling strategies
- Heavy security hardening beyond baseline

These are considered optional future enhancements, not core platform requirements.

---

## 🔜 Next Steps

Upcoming milestones include:
- Kubernetes cluster add-ons
- Ingress controller
- GitOps with ArgoCD
- Application deployment
- Observability and logging

---

## 👤 Author Notes

This project was built with a **production mindset**, emphasizing clarity, maintainability, and real DevOps workflows rather than one-off demos.
