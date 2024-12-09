variable "environment" {
  description = "Nome ambiente"
  type        = string
  default     = "production"
}

variable "project_name" {
  description  = "Descrição projeto"
  type         =  string
  default      =  "ada_contabilidade"
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

variable "email_sns" {
  description = "Email para inscrição sns"
  type        = string
}