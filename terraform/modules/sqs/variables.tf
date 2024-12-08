variable "prefix" {
  description = "Prefixo para nomear os recursos"
  type        = string
}

variable "queues" {
  description = "Mapa de configurações para filas SQS"
  type = map(object({
    name                       = string
    delay_seconds              = optional(number, 0)
    max_message_size           = optional(number, 262144)
    message_retention_seconds  = optional(number, 345600)
    visibility_timeout_seconds = optional(number, 30)
    allow_lambda_access        = optional(bool, true)
  }))
  default = {}
}