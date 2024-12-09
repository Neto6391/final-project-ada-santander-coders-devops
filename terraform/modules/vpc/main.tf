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
  count = 3

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
    Tier = "Private-App"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.availability_zones)
  
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-private-subnet-${count.index + 1}"
      Environment = var.environment
      Tier        = "Private"
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.environment}-vpc-endpoint-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-vpc-endpoint-sg"
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

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-private-route-table"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id 
  route_table_id = aws_route_table.private.id 
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-nat-eip"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_nat_gateway" "network_gateway" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.private_subnets[0].id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-nat-gateway"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  count            = var.create_s3_endpoint ? 1 : 0
  vpc_id           = aws_vpc.vpc.id
  service_name     = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private.id,
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-s3-endpoint"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint" "sqs_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.sqs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = [for subnet in aws_subnet.subnets : subnet.id if subnet.tags["Tier"] == "Private-App"]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-sqs-endpoint"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint" "sns_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.sns"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = [for subnet in aws_subnet.subnets : subnet.id if subnet.tags["Tier"] == "Private-App"]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-sns-endpoint"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private.id]

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-dynamodb-endpoint"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}



data "aws_region" "current" {}