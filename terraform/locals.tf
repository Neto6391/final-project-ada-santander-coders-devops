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
          "${aws_s3_bucket.my_bucket.arn}",
          "${aws_s3_bucket.my_bucket.arn}/*"
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
            "${aws_s3_bucket.my_bucket.arn}",
            "${aws_s3_bucket.my_bucket.arn}/*"
          ]
      }
    ]
  })

  lambda_assume_role_policy = jsonencode({
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

    lambda_s3_rds_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "rds:*",
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}
