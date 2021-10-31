# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the infrastructure resources for AWS Big Data Analytics

# VPC & Subnets
module "vpc" {
  source          = "./vpc"
  prefix          = var.prefix
  owner           = var.owner
  region          = var.region
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# S3
module "s3" {
  source = "./s3"
  prefix = var.prefix
  owner  = var.owner
}

# IAM
module "iam" {
  source                  = "./iam"
  prefix                  = var.prefix
  owner                   = var.owner
  s3_datagen_bucket_arn   = module.s3.s3_datagen_bucket_arn
  s3_resultset_bucket_arn = module.s3.s3_resultset_bucket_arn
}

# Security Group
module "sg" {
  source              = "./sg"
  prefix              = var.prefix
  owner               = var.owner
  vpc_cidr_block      = var.vpc_cidr_block
  internet_cidr_block = var.internet_cidr_block
  vpc_id              = module.vpc.vpc_id
}



# Big Data generator Instances
module "datagen" {
  source                           = "./datagen"
  prefix                           = var.prefix
  owner                            = var.owner
  region                           = var.region
  vpc_id                           = module.vpc.vpc_id
  public_subnet_id                 = module.vpc.public_subnet_id
  private_subnet_id                = module.vpc.private_subnet_id
  vpc_cidr_block                   = var.vpc_cidr_block
  internet_cidr_block              = var.internet_cidr_block
  datagen_sg_id                    = module.sg.datagen_sg_id
  datagen_instance_type            = var.datagen_instance_type
  keypair_name                     = var.keypair_name
  s3_datagen_instance_profile_name = module.iam.s3_datagen_instance_profile_name
  s3_datagen_bucket_name           = module.s3.s3_datagen_bucket_name
  data_volume_gb                   = var.data_volume_gb
}



# Athena
module "athena" {
  source                   = "./athena"
  prefix                   = var.prefix
  owner                    = var.owner
  s3_datagen_bucket_name   = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name = module.s3.s3_resultset_bucket_name
}



# Redshift
module "redshift" {
  source                    = "./redshift"
  prefix                    = var.prefix
  owner                     = var.owner
  vpc_cidr_block            = var.vpc_cidr_block
  private_subnet_id         = module.vpc.private_subnet_id
  vpc_id                    = module.vpc.vpc_id
  redshift_sg_id            = module.sg.redshift_sg_id
  redshift_cluster_type     = var.redshift_cluster_type
  redshift_node_type        = var.redshift_node_type
  redshift_number_of_nodes  = var.redshift_number_of_nodes
  redshift_master_username  = var.redshift_master_username
  redshift_master_password  = var.redshift_master_password
  s3_datagen_bucket_name    = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name  = module.s3.s3_resultset_bucket_name
  redshift_cluster_role_arn = module.iam.redshift_cluster_role_arn
}



# Metabase Server
module "metabase" {
  source                 = "./metabase"
  prefix                 = var.prefix
  owner                  = var.owner
  region                 = var.region
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  vpc_cidr_block         = var.vpc_cidr_block
  internet_cidr_block    = var.internet_cidr_block
  metabase_sg_id         = module.sg.metabase_sg_id
  metabase_instance_type = var.metabase_instance_type
  keypair_name           = var.keypair_name
}



# EMR
module "emr" {
  source                       = "./emr"
  region                       = var.region
  prefix                       = var.prefix
  owner                        = var.owner
  vpc_cidr_block               = var.vpc_cidr_block
  private_subnet_id            = module.vpc.private_subnet_id
  vpc_id                       = module.vpc.vpc_id
  emr_master_sg_id             = module.sg.emr_master_sg_id
  emr_slave_sg_id              = module.sg.emr_slave_sg_id
  emr_service_access_sg_id     = module.sg.emr_service_access_sg_id
  emr_ec2_instance_profile_arn = module.iam.emr_ec2_instance_profile_arn
  emr_service_role_arn         = module.iam.emr_service_role_arn
  emr_auto_scaling_role_arn    = module.iam.emr_auto_scaling_role_arn
  emr_release_label            = var.emr_release_label
  emr_applications             = var.emr_applications
  emr_master_instance_type     = var.emr_master_instance_type
  emr_master_number_of_nodes   = var.emr_master_number_of_nodes
  emr_core_instance_type       = var.emr_core_instance_type
  emr_core_number_of_nodes     = var.emr_core_number_of_nodes
  emr_core_ebs_volume_size     = var.emr_core_ebs_volume_size
  emr_ebs_root_volume_size     = var.emr_ebs_root_volume_size
  keypair_name                 = var.keypair_name
  s3_emr_log_bucket_name       = module.s3.s3_emr_log_bucket_name
  s3_datagen_bucket_name       = module.s3.s3_datagen_bucket_name
}



# Kinesis With Twitter
module "kinesis" {
  source                     = "./kinesis"
  prefix                     = var.prefix
  owner                      = var.owner
  kinesis_firehose_role_arn  = module.iam.kinesis_firehose_role_arn
  kinesis_analytics_role_arn = module.iam.kinesis_analytics_role_arn
  s3_datagen_bucket_name     = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name   = module.s3.s3_resultset_bucket_name
  s3_resultset_bucket_arn    = module.s3.s3_resultset_bucket_arn
}

module "twitter_kinesis" {
  source                           = "./twitter_kinesis"
  prefix                           = var.prefix
  owner                            = var.owner
  region                           = var.region
  vpc_id                           = module.vpc.vpc_id
  public_subnet_id                 = module.vpc.public_subnet_id
  private_subnet_id                = module.vpc.private_subnet_id
  vpc_cidr_block                   = var.vpc_cidr_block
  internet_cidr_block              = var.internet_cidr_block
  twitter_sg_id                    = module.sg.twitter_sg_id
  twitter_instance_type            = var.twitter_instance_type
  keypair_name                     = var.keypair_name
  s3_twitter_instance_profile_name = module.iam.s3_twitter_instance_profile_name
  s3_datagen_bucket_name           = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name         = module.s3.s3_resultset_bucket_name
  s3_resultset_bucket_arn          = module.s3.s3_resultset_bucket_arn
  consumer_key                     = var.consumer_key
  consumer_secret                  = var.consumer_secret
  access_token                     = var.access_token
  access_token_secret              = var.access_token_secret
  twitter_filter_tag               = var.twitter_filter_tag
  twitter_kinesis_stream_name      = module.kinesis.twitter_kinesis_stream_name
}



# MSK with Twitter
module "msk" {
  source                   = "./msk"
  prefix                   = var.prefix
  owner                    = var.owner
  vpc_cidr_block           = var.vpc_cidr_block
  private_subnet_id        = module.vpc.private_subnet_id
  vpc_id                   = module.vpc.vpc_id
  kafka_sg_id              = module.sg.msk_sg_id
  kafka_version            = var.kafka_version
  kafka_number_of_nodes    = var.kafka_number_of_nodes
  kafka_instance_type      = var.kafka_instance_type
  kafka_ebs_volume_size    = var.kafka_ebs_volume_size
  s3_datagen_bucket_name   = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name = module.s3.s3_resultset_bucket_name
}

module "twitter_msk" {
  source                           = "./twitter_msk"
  prefix                           = var.prefix
  owner                            = var.owner
  region                           = var.region
  vpc_id                           = module.vpc.vpc_id
  public_subnet_id                 = module.vpc.public_subnet_id
  private_subnet_id                = module.vpc.private_subnet_id
  vpc_cidr_block                   = var.vpc_cidr_block
  internet_cidr_block              = var.internet_cidr_block
  twitter_sg_id                    = module.sg.twitter_sg_id
  twitter_instance_type            = var.twitter_instance_type
  keypair_name                     = var.keypair_name
  s3_twitter_instance_profile_name = module.iam.s3_twitter_instance_profile_name
  s3_datagen_bucket_name           = module.s3.s3_datagen_bucket_name
  s3_resultset_bucket_name         = module.s3.s3_resultset_bucket_name
  s3_resultset_bucket_arn          = module.s3.s3_resultset_bucket_arn
  consumer_key                     = var.consumer_key
  consumer_secret                  = var.consumer_secret
  access_token                     = var.access_token
  access_token_secret              = var.access_token_secret
  twitter_filter_tag               = var.twitter_filter_tag
  kafka_bootstrap_servers          = module.msk.kafka_bootstrap_servers
  twitter_kafka_topic_name         = var.twitter_kafka_topic_name
}



# Optional Connect to VPC using OpenVPN Access Server
module "openvpn" {
  source                       = "./openvpn"
  prefix                       = var.prefix
  owner                        = var.owner
  vpc_id                       = module.vpc.vpc_id
  public_subnet_id             = module.vpc.public_subnet_id
  openvpn_server_ami_name      = var.openvpn_server_ami_name
  openvpn_server_instance_type = var.openvpn_server_instance_type
  vpn_admin_user               = var.vpn_admin_user
  vpn_admin_password           = var.vpn_admin_password
  keypair_name                 = var.keypair_name
}

