module "igw" {
  source = "../igw"
  environment = var.environment
}

resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  depends_on = [module.igw.internet_gateway]

  tags = {
    Name        = "${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}