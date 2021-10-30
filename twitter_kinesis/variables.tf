# Name: variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create EC2 instance for Twitter Server

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

variable "twitter_sg_id" {
  description = "Security Group for Twitter Server."
}

variable "keypair_name" {
  description = "The AWS Key pair name."
}


variable "twitter_instance_type" {
  description = "The Twitter Server Instance."
}

variable "s3_twitter_instance_profile_name" {
  description = "Twitter IAM Instance Profile Name."
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

# Twitter
variable "consumer_key" {
  description = "The Twitter API Consumer Key."
}

variable "consumer_secret" {
  description = "The Twitter API Consumer Key Secret."
}

variable "access_token" {
  description = "The Twitter API Access Token."
}

variable "access_token_secret" {
  description = "The Twitter API Access Token Secret."
}

variable "twitter_filter_tag" {
  description = "The Twitter Tweet Filter Hashtag."
}

variable "twitter_kinesis_stream_name" {
  description = "Kinesis Stream Name."
}
