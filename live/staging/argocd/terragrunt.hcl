include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "../../../modules/argocd"
}

inputs = {
  # משתמש באותו kubeconfig/context כמו המודול EKS שלך
  kubeconfig_path    = "~/.kube/config"
  kubeconfig_context = null

  argocd_namespace = "argocd"

  # אפשר לשנות בהמשך
  argocd_chart_version          = "7.7.0"
  install_applicationset        = true
  applicationset_chart_version  = "1.12.1"
}
