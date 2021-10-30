# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create MSK resources

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

variable "kafka_sg_id" {
  description = "Security Group for Kafka Cluster."
}

variable "kafka_version" {
  description = "The Kafka Version."
}

variable "kafka_number_of_nodes" {
  description = "The Number of Nodes in the Kafka Cluster."
}

variable "kafka_instance_type" {
  description = "The Kafka Node Instance Type."
}

variable "kafka_ebs_volume_size" {
  description = "The Kafka Node EBS Volume GB."
}

variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket Name for Generated Datasets."
}

variable "s3_resultset_bucket_name" {
  description = "The S3 Bucket Name for Resultset Datasets."
}
