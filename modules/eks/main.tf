module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Control Plane only
  eks_managed_node_groups = {}
  self_managed_node_groups = {}
  fargate_profiles = {}

  # Endpoint access — חשוב לשלב זה
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  tags = var.tags
}


