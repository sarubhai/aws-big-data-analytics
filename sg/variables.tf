# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create Security Groups for AWS Big Data Analytics

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
}

variable "vpc_cidr_block" {
  description = "The address space that is used by the virtual network."
}

variable "internet_cidr_block" {
  description = "The address space that is used by the internet."
}

variable "vpc_id" {
  description = "The VPC ID."
}
