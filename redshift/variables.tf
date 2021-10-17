# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create Redshift cluster resources for AWS Big Data Analytics

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
}


variable "vpc_id" {
  description = "The VPC ID."
}

variable "private_subnet_id" {
  description = "The private subnets ID."
}

variable "vpc_cidr_block" {
  description = "The address space that is used by the virtual network."
}

variable "redshift_sg_id" {
  description = "Security Group for Redshift Cluster."
}

variable "redshift_cluster_type" {
  description = "The Redshift Cluster Type."
}

variable "redshift_node_type" {
  description = "The Redshift Cluster Node Instance Type."
}

variable "redshift_number_of_nodes" {
  description = "The Number of Nodes in the Redshift Cluster."
  default     = 1
}

variable "redshift_master_username" {
  description = "The Redshift Cluster master username."
}

variable "redshift_master_password" {
  description = "The Redshift Cluster master password."
}


variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket Name for Generated Datasets."
}

variable "s3_resultset_bucket_name" {
  description = "The S3 Bucket Name for Resultset Datasets."
}

variable "redshift_cluster_role_arn" {
  description = "Redshift Cluster IAM Role ARN."
}
