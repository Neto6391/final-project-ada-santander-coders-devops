variable "environment" {
  description = "Ambiente de execução (dev, staging, prod, etc.)."
  type        = string
}

variable "rds_username" {
  description = "Usuário do banco de dados RDS."
  type        = string
}

variable "rds_password" {
  description = "Senha do banco de dados RDS."
  type        = string
  sensitive   = true
}

variable "rds_cluster_endpoint" {
  description = "Endpoint do cluster RDS."
  type        = string
}

variable "rds_db_name" {
  description = "Nome do banco de dados RDS."
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN do tópico SNS associado."
  type        = string
}

variable "create_notify_user_lambda" {
  description = "Determina se a função Lambda notify_user será criada."
  type        = bool
  default     = true
}

variable "create_event_source_mapping" {
  description = "Define se o mapeamento de eventos para a notify_user será criado."
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Nome do bucket S3 associado."
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN da fila SQS para permissões."
  type        = string
  default     = null
}