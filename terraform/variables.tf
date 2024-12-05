variable "environment" {
  description = "Nome ambiente"
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC CIDR bloco"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs para usar"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "bucket_name" {
  description = "Bucket S3 da Aplicação"
  type        = string
  default     = "application-ada-contabilidade-bucket-public-s3"
}

variable "master_password" {
  description = "Master password for the RDS"
  type        = string
  default     = "admin1234"
}

variable "iops" {
  description = "IOPS for the RDS"
  type        = number
  default     = 3000
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS"
  type        = number
  default     = 20
}

variable "iam_user_arn" {
  description = "IAM User ARN passado por GitHub Secrets"
  type        = string
}