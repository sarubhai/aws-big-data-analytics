# Name: kinesis.tf
# Owner: Saurav Mitra
# Description: This terraform config will create IAM Policies & Roles for Kinesis Services

resource "aws_iam_policy" "kinesis_firehose_policy" {
  name        = "kinesis-firehose-policy"
  path        = "/"
  description = "This policy will allow Kinesis Firehose to read records from Kinesis Stream & also to write records to S3 bucket"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          var.s3_resultset_bucket_arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${var.s3_resultset_bucket_arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:*",
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })

  tags = {
    Name  = "kinesis-firehose-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "kinesis_firehose_role" {
  name        = "kinesis-firehose-role"
  description = "Allows Kinesis Firehose Service to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.kinesis_firehose_policy.arn
  ]

  tags = {
    Name  = "kinesis-firehose-role"
    Owner = var.owner
  }
}


resource "aws_iam_policy" "kinesis_analytics_policy" {
  name        = "kinesis-analytics-policy"
  path        = "/"
  description = "This policy will allow Kinesis Analytics to read records from Kinesis Stream & also to write records Kinesis Firehose"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:*",
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "firehose:*",
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })

  tags = {
    Name  = "twitter-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "kinesis_analytics_role" {
  name        = "kinesis-analytics-role"
  description = "Allows Kinesis Analytics Service to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.kinesis_analytics_policy.arn
  ]

  tags = {
    Name  = "kinesis-analytics-role"
    Owner = var.owner
  }
}
