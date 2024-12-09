output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "subnet_ids" {
  description = "Map of subnet IDs by their tier"
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags.Tier => subnet.id...
  }
}

output "subnet_arns" {
  description = "Map of subnet ARNs by their tier"
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags.Tier => subnet.arn...
  }
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = aws_db_subnet_group.database.name
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.network_gateway[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}
