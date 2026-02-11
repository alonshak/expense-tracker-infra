variable "secret_name" {
  type        = string
  description = "Secrets Manager secret name (e.g. expense-tracker/staging/db)"
}

variable "description" {
  type        = string
  description = "Secret description"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
