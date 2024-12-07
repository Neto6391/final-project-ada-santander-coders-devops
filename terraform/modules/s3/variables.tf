variable "bucket_name" {
  description = "Bucket S3 da Aplicação"
  type        = string
  default     = "application-ada-contabilidade-bucket-public-s3"
}

variable "environment" {
  description = "Nome ambiente"
  type        = string
}

variable "iam_user_arn" {
  description = "IAM User ARN passado por GitHub Secrets"
  type        = string
}