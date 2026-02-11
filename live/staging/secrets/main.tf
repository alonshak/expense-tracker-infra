terraform {
  backend "s3" {}
}

resource "aws_secretsmanager_secret" "this" {
  name        = var.secret_name
  description = var.description

  tags = var.tags
}
