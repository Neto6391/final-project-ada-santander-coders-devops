resource "aws_sqs_queue" "process_queue" {
  name = "${var.prefix}-process-queue"
}

resource "aws_sqs_queue" "notify_queue" {
  name = "${var.prefix}-notify-queue"
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id
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
        Resource = aws_sqs_queue.my_queue.arn
      }
    ]
  })
}