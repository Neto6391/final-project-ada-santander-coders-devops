locals {
  # Gera as filas SQS baseado no mapa de configurações
  sqs_queues = { for name, config in var.queues : 
    name => {
      name                       = "${var.prefix}-${config.name}"
      delay_seconds              = config.delay_seconds
      max_message_size           = config.max_message_size
      message_retention_seconds  = config.message_retention_seconds
      visibility_timeout_seconds = config.visibility_timeout_seconds
      allow_lambda_access        = config.allow_lambda_access
    }
  }
}