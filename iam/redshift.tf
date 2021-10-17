# Name: main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create IAM Policies & Roles for Redshift Cluster

resource "aws_iam_policy" "redshift_policy" {
  name        = "redshift-policy"
  path        = "/"
  description = "This policy will allow to read & write objects to specific S3 buckets."

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
          var.s3_datagen_bucket_arn,
          var.s3_resultset_bucket_arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "${var.s3_datagen_bucket_arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${var.s3_resultset_bucket_arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name  = "redshift-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "redshift_cluster_role" {
  name        = "redshift-cluster-role"
  description = "Allows Redshift clusters to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    # "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    aws_iam_policy.redshift_policy.arn,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaRole",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  ]

  tags = {
    Name  = "redshift-cluster-role"
    Owner = var.owner
  }
}
