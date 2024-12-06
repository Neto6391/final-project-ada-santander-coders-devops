output "vpc_id" {
  description = "O ID do VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "O CIDR bloco do VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Lista de IDs publicas subnets"
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "Lista de IDs de aplicações privadas subnets"
  value       = aws_subnet.private_app[*].id
}