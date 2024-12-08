# VPC Resource
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-vpc"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_subnet" "subnets" {
  count = length(local.subnet_configs) * length(var.availability_zones)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
    var.vpc_cidr, 
    local.subnet_newbits,
    local.subnet_configs[floor(count.index / length(var.availability_zones))].cidr_offset +
    (count.index % length(var.availability_zones))
  )

  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = local.subnet_configs[floor(count.index / length(var.availability_zones))].public_ip

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-${lower(local.subnet_configs[floor(count.index / length(var.availability_zones))].tier)}-subnet-${count.index % length(var.availability_zones) + 1}"
      Environment = var.environment
      Tier        = local.subnet_configs[floor(count.index / length(var.availability_zones))].tier
      Managed_by  = "Terraform"
    }
  )
}

# Database Subnet Group
resource "aws_db_subnet_group" "database" {
  name        = "database-subnet-group-${var.environment}"
  description = "Database Subnet Group"

  subnet_ids = [
    for subnet in aws_subnet.subnets :
    subnet.id if subnet.tags.Tier == "Private-DB"
  ]

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-db-subnet-group"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

# Database Security Group
resource "aws_security_group" "database" {
  name        = "${var.environment}-database-security-group"
  description = "Database Security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-database-security-group"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

# Database Security Group Ingress Rule
resource "aws_security_group_rule" "database_ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.database.id
}

# Database Security Group Egress Rule
resource "aws_security_group_rule" "database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-nat-eip-${count.index + 1}"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_nat_gateway" "network_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.subnets[count.index].id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-nat-${count.index + 1}"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-igw"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}