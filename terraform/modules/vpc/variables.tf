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

variable "environment" {
  description = "Nome ambiente"
  type        = string
}