variable "environment" {
  description = "Nome ambiente"
  type        = string
}

variable "availability_zones" {
  description = "AZs para usar"
  type        = list(string)
}