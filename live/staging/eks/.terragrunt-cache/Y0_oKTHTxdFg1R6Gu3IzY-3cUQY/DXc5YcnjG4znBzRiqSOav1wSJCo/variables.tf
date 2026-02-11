variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the EKS control plane + node groups"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

# --- Addons toggles/config ---

variable "enable_k8s_addons" {
  description = "When true, installs EBS CSI addon + metrics-server + ingress-nginx"
  type        = bool
  default     = false
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig used by Helm/Kubernetes providers"
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Optional kubeconfig context name (leave null to use current-context)"
  type        = string
  default     = null
}

variable "enable_cert_manager" {
  description = "When true, installs cert-manager (Helm) into the cluster"
  type        = bool
  default     = true
}

variable "cert_manager_chart_version" {
  description = "Helm chart version for cert-manager"
  type        = string
  default     = "v1.14.5"
}
