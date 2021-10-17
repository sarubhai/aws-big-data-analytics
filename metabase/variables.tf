# Name: variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create EC2 instance for Metabase Server

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

variable "metabase_sg_id" {
  description = "Security Group for Metabase Server."
}

variable "keypair_name" {
  description = "The AWS Key pair name."
}

variable "metabase_instance_type" {
  description = "The Metabase Server Instance."
}
