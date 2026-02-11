include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../modules/eks"
}

inputs = {
  cluster_name    = "expense-tracker-staging"
  cluster_version = "1.29"
  route53_zone_id = "Z10467332WRJOHW6URICK"
  app_hostname    = "app.al-shak.online"
  enable_cert_manager        = true
  cert_manager_chart_version = "v1.14.5"
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids


  enable_k8s_addons = true

  tags = {
    Project     = "expense-tracker"
    Environment = "staging"
  }
}
