# ------------------------------------------------------------
# Cluster outputs
# ------------------------------------------------------------
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

# ------------------------------------------------------------
# Addons status (only meaningful when enable_k8s_addons = true)
# ------------------------------------------------------------
output "addons_status" {
  description = "Addons installation status. Values are null when enable_k8s_addons=false."
  value = {
    enabled = var.enable_k8s_addons

    ebs_csi = var.enable_k8s_addons ? {
      addon_name     = try(aws_eks_addon.ebs_csi[0].addon_name, null)
      addon_version  = try(aws_eks_addon.ebs_csi[0].addon_version, null)
      service_role   = try(aws_eks_addon.ebs_csi[0].service_account_role_arn, null)
      irsa_role_arn  = try(module.ebs_csi_irsa[0].iam_role_arn, null)
    } : null

    metrics_server = var.enable_k8s_addons ? {
      name    = try(helm_release.metrics_server[0].name, null)
      version = try(helm_release.metrics_server[0].version, null)
      status  = try(helm_release.metrics_server[0].status, null)
    } : null

    ingress_nginx = var.enable_k8s_addons ? {
      name      = try(helm_release.ingress_nginx[0].name, null)
      namespace = try(helm_release.ingress_nginx[0].namespace, null)
      version   = try(helm_release.ingress_nginx[0].version, null)
      status    = try(helm_release.ingress_nginx[0].status, null)
    } : null
  }
}
