resource "aws_s3_bucket" "ada_documents_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "ada-documents-bucket-app"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "ada_documents_bucket" {
  bucket = aws_s3_bucket.ada_documents_bucket.id
  policy = local.s3_policy
}