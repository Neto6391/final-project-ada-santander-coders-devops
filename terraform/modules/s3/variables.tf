variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "environment" {
  description = "Nome do ambiente"
  type        = string
}

variable "iam_user_arn" {
  description = "ARN do usuário IAM usado para políticas S3"
  type        = string
}
