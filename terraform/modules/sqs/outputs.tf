output "process_queue_arn" {
  value       = aws_sqs_queue.process_queue.arn
  description = "ARN da fila de processamento"
}

output "notify_queue_arn" {
  value       = aws_sqs_queue.notify_queue.arn
  description = "ARN da fila de notificações"
}