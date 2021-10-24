# outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the relevant resources ID, ARN, URL values
# https://www.terraform.io/docs/configuration/outputs.html

/*
# VPC & Subnet
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC ID."
}

output "public_subnet_id" {
  value       = module.vpc.public_subnet_id
  description = "The public subnets ID."
}

output "private_subnet_id" {
  value       = module.vpc.private_subnet_id
  description = "The private subnets ID."
}
*/


# Datagen
output "datagen_server_ip" {
  value       = module.datagen.datagen_server_ip
  description = "Datagen Server IP."
}


# Redshift
output "redshift_endpoint" {
  value       = module.redshift.redshift_endpoint
  description = "Redshift Cluster Endpoint."
}

# Redshift IAM Role
output "redshift_cluster_role_arn" {
  value       = module.iam.redshift_cluster_role_arn
  description = "Redshift Cluster IAM Role ARN."
}


# Metabase Server
output "metabase_server_ip" {
  value       = module.metabase.metabase_server_ip
  description = "Metabase Server IP."
}


# EMR
output "emr_name" {
  value       = module.emr.emr_name
  description = "EMR Cluster Name."
}

output "emr_arn" {
  value       = module.emr.emr_arn
  description = "EMR Cluster ARN."
}

output "emr_id" {
  value       = module.emr.emr_id
  description = "EMR Cluster ID."
}

output "emr_master_public_dns" {
  value       = module.emr.emr_master_public_dns
  description = "EMR Cluster Master Node DNS."
}


# Kinesis
output "twitter_server_ip" {
  value       = module.kinesis.twitter_server_ip
  description = "Twitter Server IP."
}


# OpenVPN Access Server
output "openvpn_access_server_ip" {
  value       = "https://${module.openvpn.openvpn_access_server_ip}:943/"
  description = "OpenVPN Access Server IP."
}
