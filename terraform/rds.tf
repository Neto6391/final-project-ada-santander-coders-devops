resource "aws_rds_cluster" "ada-contabilidade-database" {
  cluster_identifier        = "ada-contabilidade-database"
  availability_zones        = var.availability_zones
  db_subnet_group_name      = aws_db_subnet_group.ada-contabilidade-database.name
  engine                    = "mysql"
  engine_version            = "8.0.39"
  db_cluster_instance_class = "db.t3.micro"
  storage_type              = "gp3"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = "admin"
  master_password           = var.master_password
  skip_final_snapshot       = true
}