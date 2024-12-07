variable "sqs_queue_arn" {
  description = "ARN da fila SQS"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN do tópico SNS"
  type        = string
}

variable "rds_instance_arn" {
  description = "ARN da instância RDS"
  type        = string
}

variable "rds_cluster_endpoint" {
  description = "Endpoint da instância RDS"
  type        = string
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN do bucket S3"
  type        = string
}

variable "rds_username" {
  description = "Username RDS"
  type        = string
}

variable "rds_password" {
  description = "Password RDS"
  type        = string
}

variable "rds_db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "environment" {
  description = "Nome ambiente"
  type        = string
}