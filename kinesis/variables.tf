# Name: variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create Kinesis resources

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the name of the resources."
}


variable "kinesis_firehose_role_arn" {
  description = "Kinesis Firehose IAM Role ARN."
}

variable "kinesis_analytics_role_arn" {
  description = "Kinesis Analytics IAM Role ARN."
}

variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket for Generated Datasets."
}

variable "s3_resultset_bucket_name" {
  description = "The S3 Bucket Name for Resultset Datasets."
}

variable "s3_resultset_bucket_arn" {
  description = "The S3 Bucket ARN for Resultset Datasets."
}
