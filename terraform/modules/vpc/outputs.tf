output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID da VPC"
}

output "vpc_cidr" {
  description = "O CIDR bloco do VPC"
  value       = aws_vpc.main.cidr_block
}

output "private_subnets" {
  value       = aws_subnet.private_subnets[*].id
  description = "IDs das subnets privadas"
}

output "public_subnets" {
  value       = aws_subnet.public_subnets[*].id
  description = "IDs das subnets públicas"
}

output "database_security_group" {
  value       = aws_security_group.database_security_group.id
  description = "ID do security group para o RDS"
}

output "availability_zones" {
  description = "As zonas de disponibilidade da VPC"
  value       = var.availability_zones
}

output "database_subnet_group" {
  description = "Subnet Group do RDS na VPC"
  value       = aws_db_subnet_group.ada-contabilidade-database.name
}
