# Name: variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create EC2 instance for Datagen Server

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the name of the resources."
}

variable "region" {
  description = "The region where the resources are created."
}

variable "vpc_id" {
  description = "The VPC ID."
}

variable "public_subnet_id" {
  description = "The public subnets ID."
}

variable "private_subnet_id" {
  description = "The private subnets ID."
}

variable "vpc_cidr_block" {
  description = "The address space that is used by the virtual network."
}

variable "internet_cidr_block" {
  description = "The address space that is used by the internet."
}

variable "datagen_sg_id" {
  description = "Security Group for Datagen Server."
}

variable "keypair_name" {
  description = "The AWS Key pair name."
}

variable "datagen_instance_type" {
  description = "The Datagen Server Instance."
}

variable "s3_datagen_instance_profile_name" {
  description = "IAM Instance Profile Name."
}

variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket for Generated Datasets."
}

variable "data_volume_gb" {
  description = "The Data Volume to generate in GB."
}
