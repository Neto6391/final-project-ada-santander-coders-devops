resource "aws_sqs_queue" "queues" {
  for_each = local.sqs_queues

  name                        = each.value.name
  delay_seconds               = each.value.delay_seconds
  max_message_size            = each.value.max_message_size
  message_retention_seconds   = each.value.message_retention_seconds
  visibility_timeout_seconds  = each.value.visibility_timeout_seconds
}

resource "aws_sqs_queue_policy" "queue_policies" {
  for_each = { 
    for name, queue in local.sqs_queues : 
    name => queue if queue.allow_lambda_access 
  }

  queue_url = aws_sqs_queue.queues[each.key].id
  policy    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        Resource = aws_sqs_queue.queues[each.key].arn
      }
    ]
  })
}