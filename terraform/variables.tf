variable "environment" {
  description = "Nome ambiente"
  type        = string
  default     = "production"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
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
  sensitive   = true
}
