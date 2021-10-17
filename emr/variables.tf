# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create EMR cluster resources for AWS Big Data Analytics

variable "region" {
  description = "The region where the resources are created."
}

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


variable "emr_master_sg_id" {
  description = "Security Group for EMR Master."
}

variable "emr_slave_sg_id" {
  description = "Security Group for EMR Slave."
}

variable "emr_service_access_sg_id" {
  description = "Security Group for EMR Service Access."
}


variable "emr_ec2_instance_profile_arn" {
  description = "EMR EC2 IAM Instance Profile ARN."
}

variable "emr_service_role_arn" {
  description = "EMR Service IAM Role ARN."
}

variable "emr_auto_scaling_role_arn" {
  description = "EMR Auto Scaling IAM Role ARN."
}


variable "emr_release_label" {
  description = "EMR Cluster Release Label."
}

variable "emr_applications" {
  description = "EMR Cluster Installed Applications List."
}

variable "emr_master_instance_type" {
  description = "The EMR Master Node Instance Type."
}

variable "emr_master_number_of_nodes" {
  description = "The Number of Master Nodes in the EMR Cluster."
}

variable "emr_core_instance_type" {
  description = "The EMR Core Node Instance Type."
}

variable "emr_core_number_of_nodes" {
  description = "The Number of Core Nodes in the EMR Cluster."
}

variable "emr_core_ebs_volume_size" {
  description = "The EMR Core Nodes EBS Volume Size in GB."
}

variable "emr_ebs_root_volume_size" {
  description = "The EMR All Nodes Root Volume Size in GB."
}

variable "keypair_name" {
  description = "The AWS Key pair name."
}

variable "s3_emr_log_bucket_name" {
  description = "The S3 Bucket Name for EMR Logs."
}

variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket Name for Generated Datasets."
}
