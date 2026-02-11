terraform {
  backend "s3" {}
}

resource "aws_secretsmanager_secret" "db" {
  name        = var.secret_name
  description = var.description

  tags = var.tags
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.db.name
}
