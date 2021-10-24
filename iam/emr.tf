# Name: emr.tf
# Owner: Saurav Mitra
# Description: This terraform config will create IAM Policies & Roles for EMR Cluster

# EMR Service
resource "aws_iam_policy" "emr_service_policy" {
  name        = "emr_service-policy"
  path        = "/"
  description = "EMR Service Policy."
  # arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CancelSpotInstanceRequests",
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateNetworkInterface",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteTags",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribePrefixLists",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcEndpointServices",
          "ec2:DescribeVpcs",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:RequestSpotInstances",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListInstanceProfiles",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "s3:CreateBucket",
          "s3:Get*",
          "s3:List*",
          "sdb:BatchPutAttributes",
          "sdb:Select",
          "sqs:CreateQueue",
          "sqs:Delete*",
          "sqs:GetQueue*",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms",
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot*",
        "Condition" : {
          "StringLike" : {
            "iam:AWSServiceName" : "spot.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name  = "emr-service-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "emr_service_role" {
  name        = "emr-service-role"
  description = "EMR Service Role."
  # arn:aws:iam::583630561065:role/EMR_DefaultRole

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.emr_service_policy.arn
  ]

  tags = {
    Name  = "emr-service-role"
    Owner = var.owner
  }
}


# EMR EC2
resource "aws_iam_policy" "emr_ec2_policy" {
  name        = "emr_ec2-policy"
  path        = "/"
  description = "EMR EC2 Policy."
  # arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:*",
          "dynamodb:*",
          "ec2:Describe*",
          "elasticmapreduce:Describe*",
          "elasticmapreduce:ListBootstrapActions",
          "elasticmapreduce:ListClusters",
          "elasticmapreduce:ListInstanceGroups",
          "elasticmapreduce:ListInstances",
          "elasticmapreduce:ListSteps",
          "kinesis:CreateStream",
          "kinesis:DeleteStream",
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:MergeShards",
          "kinesis:PutRecord",
          "kinesis:SplitShard",
          "rds:Describe*",
          "s3:*",
          "sdb:*",
          "sns:*",
          "sqs:*",
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersions",
          "glue:CreatePartition",
          "glue:BatchCreatePartition",
          "glue:UpdatePartition",
          "glue:DeletePartition",
          "glue:BatchDeletePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition",
          "glue:CreateUserDefinedFunction",
          "glue:UpdateUserDefinedFunction",
          "glue:DeleteUserDefinedFunction",
          "glue:GetUserDefinedFunction",
          "glue:GetUserDefinedFunctions"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name  = "emr-ec2-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "emr_ec2_role" {
  name        = "emr-ec2-role"
  description = "EMR EC2 Role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.emr_ec2_policy.arn
  ]

  tags = {
    Name  = "emr-ec2-role"
    Owner = var.owner
  }
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = "emr-ec2-instance-profile"
  role = aws_iam_role.emr_ec2_role.name
}



# EMR Auto Scaling
resource "aws_iam_policy" "emr_auto_scaling_policy" {
  name        = "emr_auto-scaling-policy"
  path        = "/"
  description = "EMR Auto Scaling Policy."
  # arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:DescribeAlarms",
          "elasticmapreduce:ListInstanceGroups",
          "elasticmapreduce:ModifyInstanceGroups"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name  = "emr-auto-scaling-policy"
    Owner = var.owner
  }
}

resource "aws_iam_role" "emr_auto_scaling_role" {
  name        = "emr-auto-scaling-role"
  description = "EMR Auto Scaling Role."
  # EMR_AutoScaling_DefaultRole

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "elasticmapreduce.amazonaws.com",
            "application-autoscaling.amazonaws.com"
          ]
        }
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.emr_ec2_policy.arn
  ]

  tags = {
    Name  = "emr-auto-scaling-role"
    Owner = var.owner
  }
}
