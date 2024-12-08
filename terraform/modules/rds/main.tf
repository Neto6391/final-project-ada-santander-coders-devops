resource "aws_db_subnet_group" "database" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-db-subnet-group"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}

resource "aws_db_instance" "database" {
  identifier = "${var.environment}-database"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  username = var.db_username
  password = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [var.database_security_group_id]
  instance_class      = var.db_instance_class
  allocated_storage   = var.allocated_storage
  storage_type        = var.storage_type
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  multi_az               = var.multi_az
  publicly_accessible    = false
  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = var.skip_final_snapshot
  db_name          = var.database_name

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-database"
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  )
}