module "vpc" {
  source =  "../vpc"
  environment = var.environment
}

resource "aws_rds_cluster" "ada-contabilidade-database" {
  cluster_identifier        = "ada-contabilidade-database"
  availability_zones        = module.vpc.availability_zones
  db_subnet_group_name      = module.vpc.database_subnet_group
  engine                    = "postgres"
  engine_version            = "13.7"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io2"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = var.master_username
  master_password           = var.master_password
  skip_final_snapshot       = true
  vpc_security_group_ids  = [module.vpc.database_security_group]
  database_name           = var.database_name
}