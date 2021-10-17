# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the IAM Role ARN & Id

output "s3_datagen_role_arn" {
  value       = aws_iam_role.datagen_role.arn
  description = "S3 Access IAM Role ARN."
}

output "s3_datagen_instance_profile_name" {
  value       = aws_iam_instance_profile.datagen_instance_profile.name
  description = "S3 Access IAM Instance Profile Name."
}


output "redshift_cluster_role_arn" {
  value       = aws_iam_role.redshift_cluster_role.arn
  description = "Redshift Cluster IAM Role ARN."
}


output "emr_ec2_instance_profile_arn" {
  value       = aws_iam_instance_profile.emr_ec2_instance_profile.arn
  description = "EMR EC2 IAM Instance Profile ARN."
}

output "emr_service_role_arn" {
  value       = aws_iam_role.emr_service_role.arn
  description = "EMR Service IAM Role ARN."
}

output "emr_auto_scaling_role_arn" {
  value       = aws_iam_role.emr_auto_scaling_role.arn
  description = "EMR Auto Scaling IAM Role ARN."
}
