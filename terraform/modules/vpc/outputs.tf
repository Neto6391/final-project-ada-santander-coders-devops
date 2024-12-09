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
    for tier in distinct([for subnet in aws_subnet.subnets : subnet.tags.Tier]) :
    tier => [
      for subnet in aws_subnet.subnets :
      subnet.id if subnet.tags.Tier == tier
    ]
  }
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.network_gateway[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}