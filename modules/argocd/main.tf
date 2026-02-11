terraform {
  backend "s3" {}

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kubeconfig_context
}

provider "helm" {
  kubernetes = {
    config_path    = pathexpand(var.kubeconfig_path)
    config_context = var.kubeconfig_context
  }
}

# -----------------------------
# Argo CD (core)
# -----------------------------
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = var.argocd_namespace
  create_namespace = true

  # חשוב: CRDs דרך Helm (פחות בעיות של annotation "Too long")
  set = {
    name  = "crds.install"
    value = "true"
  }
}

# -----------------------------
# ApplicationSet (כדי להבטיח שיש CRD applicationsets.argoproj.io)
# אם אצלך כבר מגיע "בילט-אין" בגרסה מסוימת של chart, אפשר לכבות עם var.
# -----------------------------
resource "helm_release" "applicationset" {
  count            = var.install_applicationset ? 1 : 0
  name             = "argocd-applicationset"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-applicationset"
  version          = var.applicationset_chart_version
  namespace        = var.argocd_namespace
  create_namespace = true

  depends_on = [helm_release.argocd]
}
