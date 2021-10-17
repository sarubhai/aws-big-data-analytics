# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create IAM Policies & Roles

variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
}

# S3
variable "s3_datagen_bucket_arn" {
  description = "The S3 Bucket ARN for Generated Datasets."
}

variable "s3_resultset_bucket_arn" {
  description = "The S3 Bucket ARN for Resultset Datasets."
}
