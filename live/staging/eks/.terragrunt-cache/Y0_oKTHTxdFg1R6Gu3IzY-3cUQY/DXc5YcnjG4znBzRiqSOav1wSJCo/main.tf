terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

# ------------------------------------------------------------
# 1) EKS Cluster + Node Group
# ------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  eks_managed_node_groups = {
    default = {
      name = "default-node-group"

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      min_size       = 3
      max_size       = 4
      desired_size   = 3

      subnet_ids = var.private_subnet_ids

      tags = {
        Name = "expense-tracker-node"
      }
    }
  }

  self_managed_node_groups = {}
  fargate_profiles         = {}

  # Endpoint access — חשוב לשלב זה
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # FIX: allow node-to-node / pod-to-pod traffic across nodes
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow all traffic within node SG (cross-node pod traffic / ingress-nginx upstream)"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------
# 2) IRSA role for EBS CSI (only when enable_k8s_addons = true)
# ------------------------------------------------------------
module "ebs_csi_irsa" {
  count   = var.enable_k8s_addons ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-ebs-csi-driver-role"

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "kube-system:ebs-csi-controller-sa"
      ]
    }
  }

  attach_ebs_csi_policy = true
}

# ------------------------------------------------------------
# 3) EKS Managed Addon: aws-ebs-csi-driver (pin most-recent supported version)
# ------------------------------------------------------------
data "aws_eks_addon_version" "ebs_csi" {
  count              = var.enable_k8s_addons ? 1 : 0
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "ebs_csi" {
  count        = var.enable_k8s_addons ? 1 : 0
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  addon_version            = data.aws_eks_addon_version.ebs_csi[0].version
  service_account_role_arn = module.ebs_csi_irsa[0].iam_role_arn

  depends_on = [module.eks]
}

# ------------------------------------------------------------
# 4) Kubernetes / Helm Providers via kubeconfig
#    (will be used after aws eks update-kubeconfig)
# ------------------------------------------------------------
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

# ------------------------------------------------------------
# IRSA role for External Secrets Operator (ESO)
# ------------------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eso_secretsmanager" {
  statement {
    sid    = "ReadStagingDbSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:expense-tracker/staging/db*"
    ]
  }
}

resource "aws_iam_policy" "eso_secretsmanager" {
  count  = var.enable_k8s_addons ? 1 : 0
  name   = "${var.cluster_name}-external-secrets-sm-read"
  policy = data.aws_iam_policy_document.eso_secretsmanager.json
}

module "external_secrets_irsa" {
  count   = var.enable_k8s_addons ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-external-secrets-role"

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "external-secrets:external-secrets"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "external_secrets_sm_attach" {
  count      = var.enable_k8s_addons ? 1 : 0
  role       = module.external_secrets_irsa[0].iam_role_name
  policy_arn = aws_iam_policy.eso_secretsmanager[0].arn
}

# ------------------------------------------------------------
# 5) Helm addons (metrics-server, ingress-nginx, external-secrets)
# ------------------------------------------------------------
resource "helm_release" "metrics_server" {
  count = var.enable_k8s_addons ? 1 : 0

  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  create_namespace = false

  depends_on = [module.eks]
}

resource "helm_release" "ingress_nginx" {
  count = var.enable_k8s_addons ? 1 : 0

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    }
  ]

  depends_on = [module.eks]
}

resource "helm_release" "external_secrets" {
  count = var.enable_k8s_addons ? 1 : 0

  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "external-secrets"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.external_secrets_irsa[0].iam_role_arn
    }
  ]

  depends_on = [module.eks, module.external_secrets_irsa, aws_iam_role_policy_attachment.external_secrets_sm_attach]
}

