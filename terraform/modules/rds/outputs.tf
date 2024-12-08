output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.database.endpoint
  sensitive   = true
}

output "db_instance_port" {
  description = "The port on which the database accepts connections"
  value       = aws_db_instance.database.port
}

output "db_instance_name" {
  description = "The name of the database instance"
  value       = aws_db_instance.database.identifier
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.database.name
}