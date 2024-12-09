variable "environment" {
  description = "Environment name"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "hash_key" {
  description = "The hash key (primary key) of the table."
  type        = string
}

variable "attributes" {
  description = "List of attributes for the DynamoDB table. Each attribute must have 'name' and 'type'."
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = optional(string)
    projection_type = optional(string, "ALL")
    read_capacity   = optional(number)
    write_capacity  = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to DynamoDB resources"
  type        = map(string)
  default     = {}
}

variable "attributes" {
  description = "List of attributes for DynamoDB table"
  type        = list(map(string))
  default = [
    { name = "file_id", type = "S" },
    { name = "file_name", type = "S" },
    { name = "created_at", type = "S" }
  ]
}

variable "index" {
  description = "List of global secondary indexes"
  type = list(object({
    name       = string
    hash_key   = string
    projection = string
  }))
  default = [
    {
      name       = "FileNameIndex",
      hash_key   = "file_name",
      projection = "ALL"
    }
  ]
}