resource "aws_s3_bucket" "ada_documents_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "ada-documents-bucket-app-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.ada_documents_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "ada_documents_bucket" {
  bucket = aws_s3_bucket.ada_documents_bucket.id
  policy = jsonencode(
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.iam_user_arn
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Resource" : [
            aws_s3_bucket.ada_documents_bucket.arn,
          "${aws_s3_bucket.ada_documents_bucket.arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
          "Action" : [
            "s3:GetObject",
            "s3:GetObjectAttributes",
            "s3:ListBucket"
          ],
          "Resource" : [
              aws_s3_bucket.ada_documents_bucket.arn,
            "${aws_s3_bucket.ada_documents_bucket.arn}/*"
          ]
      }
    ]
  })
}