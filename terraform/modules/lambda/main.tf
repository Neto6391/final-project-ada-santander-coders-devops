
resource "aws_lambda_function" "generate_file" {
  function_name = "generate_file"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../../../packages/generate_file.zip"

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}


resource "aws_lambda_function" "process_file" {
  function_name = "process_file"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../../../packages/process_file.zip"

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
}

resource "aws_lambda_function" "notify_user" {
  function_name = "notify_user"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.9"
  filename      = "../../../packages/notify_user.zip"

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "notify_user_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.notify_user.arn
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = local.lambda_policy
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}