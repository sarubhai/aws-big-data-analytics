# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create Athena resources for AWS Big Data Analytics

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
}

variable "s3_datagen_bucket_name" {
  description = "The S3 Bucket Name for Generated Datasets."
}

variable "s3_resultset_bucket_name" {
  description = "The S3 Bucket Name for Resultset Datasets."
}
