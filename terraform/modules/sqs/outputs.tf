output "queue_arns" {
  description = "ARNs das filas SQS criadas"
  value       = { for name, queue in aws_sqs_queue.queues : name => queue.arn }
}

output "queue_urls" {
  description = "URLs das filas SQS criadas"
  value       = { for name, queue in aws_sqs_queue.queues : name => queue.url }
}