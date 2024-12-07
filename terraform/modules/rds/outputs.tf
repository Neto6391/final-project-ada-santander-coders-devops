output "rds_cluster_identifier" {
  description = "O identificador do cluster RDS"
  value       = aws_rds_cluster.ada-contabilidade-database.cluster_identifier
}

output "rds_cluster_endpoint" {
  description = "O endpoint do cluster RDS"
  value = aws_rds_cluster.ada-contabilidade-database.endpoint
}

output "rds_cluster_arn" {
  description = "O ARN do cluster RDS"
  value       = aws_rds_cluster.ada-contabilidade-database.arn
}

output "rds_database_name" {
  description = "Nome do banco de dados"
  value       = var.database_name
}