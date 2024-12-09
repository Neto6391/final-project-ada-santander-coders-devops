locals {
  lambda_common_config = {
    handler = "index.lambda_handler"
    runtime = "python3.8"
  }

  lambda_functions = {
    "generate_file" = {
      create        = true
      function_name = "ada-generate-file-${var.environment}"
      filename      = "../packages/generate_file.zip"
      env_vars      = { 
        BUCKET_NAME = var.bucket_name 
      }
    }
    "process_file" = {
      create        = true
      function_name = "ada-process-file-${var.environment}"
      filename      = "../packages/process_file.zip"
      env_vars      = {
        DB_USERNAME     = var.rds_username
        DB_PASSWORD     = var.rds_password
        DB_HOST         = var.rds_cluster_endpoint
        DB_NAME         = var.rds_db_name
        SNS_TOPIC_ARN   = var.sns_topic_arn
      }
    }
    "notify_user" = {
      create        = var.create_notify_user_lambda
      function_name = "ada-notify-user-${var.environment}"
      filename      = "../packages/notify_user.zip"
      env_vars      = { 
        SNS_TOPIC_ARN = var.sns_topic_arn 
      }
    }
  }

  process_file_lambda = {
    arn  = [for k, v in aws_lambda_function.ada_lambda : v.arn if k == "process_file"][0]
    name = [for k, v in aws_lambda_function.ada_lambda : v.function_name if k == "process_file"][0]
  }

  notify_user_lambda = {
    arn  = [for k, v in aws_lambda_function.ada_lambda : v.arn if k == "notify_user"][0]
  }
}

resource "aws_lambda_function" "ada_lambda" {
  for_each = { for k, v in local.lambda_functions : k => v if v.create }

  function_name = each.value.function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.8"
  filename      = each.value.filename  

  memory_size = 512
  timeout     = 120

  environment {
    variables = each.value.env_vars
  }

  layers = each.key == "process_file" ? [aws_lambda_layer_version.psycopg2_layer.arn] : []

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
    vpc_endpoint_ids = [var.vpc_endpoints_ids]
  }

}

resource "aws_lambda_layer_version" "psycopg2_layer" {
  filename   = "../packages/psycopg2_layer.zip"
  layer_name = "psycopg2-layer-${var.environment}"
  compatible_runtimes = ["python3.8"]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = local.process_file_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_call_lambda]
}

resource "aws_lambda_permission" "allow_s3_to_call_lambda" {
  statement_id  = "AllowS3ToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = local.process_file_lambda.name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

resource "aws_lambda_event_source_mapping" "notify_user_trigger" {
  count = var.create_event_source_mapping ? 1 : 0

  event_source_arn = var.sqs_queue_arn
  function_name    = local.notify_user_lambda.arn
  batch_size       = 1
  enabled          = true
}
