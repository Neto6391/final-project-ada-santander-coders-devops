variable "environment" {
  description = "Nome ambiente"
  type        = string
  default     = "production"
}

variable "iam_user_arn" {
  description = "IAM User ARN passado por GitHub Secrets"
  type        = string
}

variable "master_username_rds" {
  description = "Master username do RDS por GitHub Secrets"
  type        = string
}

variable "master_password_rds" {
  description = "Master password do RDS por GitHub Secrets"
  type        = string
}
