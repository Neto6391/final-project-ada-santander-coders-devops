resource "aws_lambda_function" "gerador_arquivo" {
  function_name = "gerador-arquivo-lambda"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.9"

  filename         = "dist/gerador-lambda.zip"
  source_code_hash = filebase64sha256("dist/gerador-lambda.zip")

  vpc_config {
    subnet_ids         = aws_subnet.private_subnets[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.arquivo_bucket.id
    }
  }
}

resource "aws_lambda_function" "processador_arquivo" {
  function_name = "processador-arquivo-lambda"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.9"

  filename         = "dist/processador-lambda.zip"
  source_code_hash = filebase64sha256("dist/processador-lambda.zip")

  vpc_config {
    subnet_ids         = aws_subnet.private_subnets[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      RDS_HOST     = aws_db_instance.file_metadata.endpoint
      RDS_DATABASE = "file_tracking"
    }
  }
}

resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processador_arquivo.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.arquivo_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.arquivo_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processador_arquivo.arn
    events              = ["s3:ObjectCreated:*"]
  }
}