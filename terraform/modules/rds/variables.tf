variable "master_username" {
  description = "Master password for the RDS"
  type        = string
}

variable "master_password" {
  description = "Master password for the RDS"
  type        = string
}

variable "iops" {
  description = "IOPS for the RDS"
  type        = number
  default     = 3000
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS"
  type        = number
  default     = 400
}

variable "database_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "ada-contabilidade-database"
}

variable "environment" {
  description = "Nome ambiente"
  type        = string
}