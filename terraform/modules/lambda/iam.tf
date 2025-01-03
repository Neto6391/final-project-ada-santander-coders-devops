resource "aws_iam_role" "lambda_execution_role" {
  name               = "${var.environment}_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.environment}_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ]
        Effect   = "Allow"
        Resource = var.sqs_queue_arn
      },
      {
        Action = "sns:Publish"
        Effect = "Allow"
        Resource = var.sns_topic_arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "lambda:PublishLayerVersion",
          "lambda:DeleteLayerVersion",
          "lambda:GetLayerVersion",
          "lambda:ListLayerVersions",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.dynamodb_table}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}