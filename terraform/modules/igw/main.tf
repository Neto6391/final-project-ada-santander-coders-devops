module "vpc" {
  source = "../igw"
  environment = var.environment
}

resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}