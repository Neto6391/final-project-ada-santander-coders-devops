module "vpc" {
  source =  "../vpc"
  environment = var.environment
}

resource "aws_rds_cluster" "ada-contabilidade-database" {
  cluster_identifier        = "ada-contabilidade-database"
  availability_zones        = module.vpc.availability_zones
  db_subnet_group_name      = module.vpc.database_subnet_group
  engine                    = "mysql"
  engine_version            = "8.0.39"
  db_cluster_instance_class = "db.t3.medium"
  storage_type              = "gp3"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = var.master_username
  master_password           = var.master_password
  skip_final_snapshot       = true
  vpc_security_group_ids  = [module.vpc.database_security_group]
  database_name           = var.database_name
}