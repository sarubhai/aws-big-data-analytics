# Name: main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create IAM Policies & Roles for BigData Generation Instance

resource "aws_iam_policy" "datagen_policy" {
  name        = "datagen-policy"
  path        = "/"
  description = "This policy will allow an EC2 instance to write objects to bigdatagen bucket in S3. It will also allow to terminate the instance after work done."

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
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${var.s3_datagen_bucket_arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ],
        "Resource" : [
          "arn:aws:ec2:*:*:instance/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/Name" : "BigDataGenerator"
          }
        },
      }
    ]
  })

  tags = {
    Name  = "datagen-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "datagen_role" {
  name        = "datagen-role"
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
    aws_iam_policy.datagen_policy.arn
  ]

  tags = {
    Name  = "datagen-role"
    Owner = var.owner
  }
}

resource "aws_iam_instance_profile" "datagen_instance_profile" {
  name = "datagen-role"
  role = aws_iam_role.datagen_role.name
}
