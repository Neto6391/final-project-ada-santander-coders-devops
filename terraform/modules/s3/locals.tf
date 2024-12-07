locals {
  s3_policy = jsonencode(
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
          "${aws_s3_bucket.ada_documents_bucket.arn}",
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
            "${aws_s3_bucket.ada_documents_bucket.arn}",
            "${aws_s3_bucket.ada_documents_bucket.arn}/*"
          ]
      }
    ]
  })
}