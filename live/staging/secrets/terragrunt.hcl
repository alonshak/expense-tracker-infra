include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/secrets"
}

inputs = {
  secret_name  = "expense-tracker/staging/db"
  description  = "DB credentials for expense-tracker staging (used by External Secrets Operator)"

  tags = {
    project     = "expense-tracker"
    environment = "staging"
  }
}
