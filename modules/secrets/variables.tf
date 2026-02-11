variable "secret_name" {
  type        = string
  description = "Secrets Manager secret name"
}

variable "description" {
  type        = string
  default     = ""
  description = "Secret description"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the secret"
}
