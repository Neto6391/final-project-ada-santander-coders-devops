
resource "aws_lambda_function" "generate_file" {
  function_name = "ada-generate-file-${var.environment}"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../packages/generate_file.zip"

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}


resource "aws_lambda_function" "process_file" {
  function_name = "ada-process-file-${var.environment}"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../packages/process_file.zip"

  environment {
    variables = {
      DB_USERNAME = var.rds_username
      DB_PASSWORD = var.rds_password
      DB_HOST = var.rds_cluster_endpoint
      DB_NAME = var.rds_db_name
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "process_file_trigger" {
  event_source_arn = var.s3_bucket_arn
  function_name    = aws_lambda_function.process_file.arn

  batch_size       = 10
  enabled          = true

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]
}

resource "aws_lambda_function" "notify_user" {
  function_name = "ada-notify-user-${var.environment}"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../packages/notify_user.zip"

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "notify_user_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.notify_user.arn

  batch_size       = 1
  enabled          = true

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = local.lambda_policy
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}