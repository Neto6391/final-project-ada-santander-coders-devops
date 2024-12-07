output "bucket_name" {
  value = aws_s3_bucket.ada_documents_bucket.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.ada_documents_bucket.arn
}