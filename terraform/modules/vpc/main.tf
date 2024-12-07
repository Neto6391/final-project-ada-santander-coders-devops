resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Tier        = "Public"
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-private-app-subnet-${count.index + 1}"
    Environment = var.environment
    Tier        = "private-app"
    Managed_by  = "terraform"
  }
}

resource "aws_db_subnet_group" "ada-contabilidade-database" {
  name        = "ada-contabilidade-database"
  description = "Grupo de Subnet para banco de dados RDS"
  subnet_ids  = aws_subnet.private_db[*].id

  depends_on = [aws_subnet.private_db]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "private_db" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + 8)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-private-db-subnet-${count.index + 1}"
    Environment = var.environment
    Tier        = "private-db"
    Managed_by  = "terraform"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "database-sec"
  description = "Allow MySQL inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "database_security_group"
  }
}

resource "aws_security_group_rule" "database_security_group_ingress_rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.database_security_group.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_security_group_rule" "database_security_group_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}