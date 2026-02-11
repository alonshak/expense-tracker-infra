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

variable "argocd_namespace" {
  description = "Namespace to install Argo CD into"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Helm chart version for argo-cd"
  type        = string
  default     = "7.7.0"
}

variable "install_applicationset" {
  description = "Install argocd-applicationset chart to ensure ApplicationSet CRD exists"
  type        = bool
  default     = true
}

variable "applicationset_chart_version" {
  description = "Helm chart version for argocd-applicationset"
  type        = string
  default     = "1.12.1"
}
