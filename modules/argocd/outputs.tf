output "argocd_namespace" {
  value = var.argocd_namespace
}

output "argocd_release" {
  value = helm_release.argocd.name
}

output "applicationset_release" {
  value = var.install_applicationset ? helm_release.applicationset[0].name : null
}
