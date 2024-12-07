resource "aws_sqs_queue" "process_queue" {
  name = "${var.prefix}-process-queue"
}

resource "aws_sqs_queue" "notify_queue" {
  name = "${var.prefix}-notify-queue"
}