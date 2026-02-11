resource "helm_release" "cert_manager" {
  count = (var.enable_k8s_addons && var.enable_cert_manager) ? 1 : 0

  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_chart_version
  namespace        = "cert-manager"
  create_namespace = true

  # חשוב: cert-manager צריך CRDs
  set = [
    {
    name  = "installCRDs"
    value = "true"
  }
  ]
  depends_on = [module.eks]
}
