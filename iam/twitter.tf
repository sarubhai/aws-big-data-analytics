# Name: twitter.tf
# Owner: Saurav Mitra
# Description: This terraform config will create IAM Policies & Roles for Twitter Instance

resource "aws_iam_policy" "twitter_policy" {
  name        = "twitter-policy"
  path        = "/"
  description = "This policy will allow an EC2 instance to read objects from bigdatagen bucket in S3, and put records into Kinesis"

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
          var.s3_datagen_bucket_arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
        ],
        "Resource" : [
          "${var.s3_datagen_bucket_arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:DescribeStream",
          "iam:SimulatePrincipalPolicy",
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

resource "aws_iam_role" "twitter_role" {
  name        = "twitter-role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.twitter_policy.arn
  ]

  tags = {
    Name  = "twitter-role"
    Owner = var.owner
  }
}

resource "aws_iam_instance_profile" "twitter_instance_profile" {
  name = "twitter-role"
  role = aws_iam_role.twitter_role.name
}
