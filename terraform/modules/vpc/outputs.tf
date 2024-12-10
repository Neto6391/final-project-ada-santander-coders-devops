output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
  description = "The IDs of the private subnets"
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.network_gateway[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}

output "vpc_endpoint_sg_id" {
  description = "The security group ID for Lambda"
  value = aws_security_group.vpc_endpoint_sg.id
}