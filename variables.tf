# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create the infrastructure resources for AWS Big Data Analytics 
# https://www.terraform.io/docs/configuration/variables.html

# Region
variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}


# Tags
variable "prefix" {
  description = "This prefix will be included in the name of the resources."
  default     = "AwsBigData"
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
  default     = "Saurav Mitra"
}


# VPC & Subnets
variable "vpc_cidr_block" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A map of availability zones to CIDR blocks to use for the public subnet."
  default = {
    ap-southeast-1a = "10.0.0.0/24"
  }
}

variable "private_subnets" {
  description = "A map of availability zones to CIDR blocks to use for the private subnet."
  default = {
    ap-southeast-1a = "10.0.1.0/24"
    ap-southeast-1b = "10.0.2.0/24"
    ap-southeast-1c = "10.0.3.0/24"
  }
}

variable "internet_cidr_block" {
  description = "The address space that is used by the internet."
  default     = "0.0.0.0/0"
}


# AWS EC2 KeyPair
variable "keypair_name" {
  description = "The AWS Key pair name."
}


# Datagen
variable "datagen_instance_type" {
  description = "The Datagen Server Instance."
  default     = "t2.large"
}

variable "data_volume_gb" {
  description = "The Data Volume to generate in GB."
  default     = 1
}


# Redshift
variable "redshift_cluster_type" {
  description = "The Redshift Cluster Type."
  default     = "single-node" # multi-node
}

variable "redshift_node_type" {
  description = "The Redshift Cluster Node Instance Type."
  default     = "dc2.large"
}

variable "redshift_number_of_nodes" {
  description = "The Number of Nodes in the Redshift Cluster."
  default     = 1
}

variable "redshift_master_username" {
  description = "The Redshift Cluster master username."
  default     = "adminuser"
}

variable "redshift_master_password" {
  description = "The Redshift Cluster master password."
  default     = "Passw0rd1234"
}


# Metabase
variable "metabase_instance_type" {
  description = "The Metabase Server Instance."
  default     = "t2.medium"
}


# EMR
variable "emr_release_label" {
  description = "EMR Cluster Release Label."
  default     = "emr-6.4.0" # "emr-5.33.1"
}

variable "emr_applications" {
  description = "EMR Cluster Installed Applications List."
  default     = ["Hadoop", "Tez", "Hive", "Hcatalog", "Pig", "Spark", "Presto", "Hue", "JupyterHub", "JupyterEnterpriseGateway"]
}

variable "emr_master_instance_type" {
  description = "The EMR Master Node Instance Type."
  default     = "m5.xlarge"
}

variable "emr_master_number_of_nodes" {
  description = "The Number of Master Nodes in the EMR Cluster."
  default     = 1
}

variable "emr_core_instance_type" {
  description = "The EMR Core Node Instance Type."
  default     = "m5.xlarge"
}

variable "emr_core_number_of_nodes" {
  description = "The Number of Core Nodes in the EMR Cluster."
  default     = 2
}

variable "emr_core_ebs_volume_size" {
  description = "The EMR Core Nodes EBS Volume Size in GB."
  default     = 100
}

variable "emr_ebs_root_volume_size" {
  description = "The EMR All Nodes Root Volume Size in GB."
  default     = 100
}


# Kinesis

# Twitter
variable "twitter_instance_type" {
  description = "The Twitter Server Instance."
  default     = "t2.micro"
}

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
  default     = "#Covid19"
}


# OpenVPN Access Server
variable "openvpn_server_ami_name" {
  description = "The OpenVPN Access Server AMI Name."
  default     = "OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931-ami-06585f7cf2fb8855c.4"
}

variable "openvpn_server_instance_type" {
  description = "The OpenVPN Access Server Instance Type."
  default     = "t2.micro"
}

variable "vpn_admin_user" {
  description = "The OpenVPN Admin User."
  default     = "openvpn"
}

variable "vpn_admin_password" {
  description = "The OpenVPN Admin Password."
}
