variable "environment" {
  description = "Ambiente de execução (dev, staging, prod, etc.)."
  type        = string
}

variable "dynamodb_table" {
  description = "Nome do banco de dados DynamoDB."
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

variable "subnet_ids" {
  description = "Lista de subnets onde a função Lambda deve ser colocada"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Lista de IDs de Security Groups para associar à função Lambda"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "vpc_endpoints" {
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Região AWS onde os recursos estão configurados"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "ID da conta AWS"
  type        = string
}