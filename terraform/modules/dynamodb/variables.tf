variable "environment" {
  description = "Environment name"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "Hash key for the DynamoDB table"
  type        = string
}

variable "attributes" {
  description = "List of attributes for DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "index" {
  description = "List of global secondary indexes"
  type = list(object({
    name       = string
    hash_key   = string
    projection = string
  }))
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name            = string
    hash_key        = string
    projection_type = string
  }))
}
