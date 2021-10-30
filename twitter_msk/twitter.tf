# Name: twitter.tf
# Owner: Saurav Mitra
# Description: This terraform config will create a EC2 instance for Twitter Server

# Amazon Linux AMI Filter
data "aws_ami" "twitter_kafka_linux" {
  owners      = ["137112412989"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# User Data Init
data "template_file" "twitter_kafka_init_script" {
  template = templatefile("${path.module}/twitter_server.sh", {
    s3_datagen_bucket_name = var.s3_datagen_bucket_name
    consumer_key           = var.consumer_key,
    consumer_secret        = var.consumer_secret,
    access_token           = var.access_token,
    access_token_secret    = var.access_token_secret,
    twitter_filter_tag     = var.twitter_filter_tag,
    kafka_topic_name       = var.twitter_kafka_topic_name
    bootstrap_servers      = var.kafka_bootstrap_servers
  })
}


# EC2 Instance
resource "aws_instance" "twitter_kafka_server" {
  ami                    = data.aws_ami.twitter_kafka_linux.id
  instance_type          = var.twitter_instance_type
  subnet_id              = var.private_subnet_id[0]
  vpc_security_group_ids = [var.twitter_sg_id]
  key_name               = var.keypair_name
  source_dest_check      = false

  root_block_device {
    volume_size           = 20
    delete_on_termination = true
  }

  iam_instance_profile = var.s3_twitter_instance_profile_name

  tags = {
    Name  = "TwitterKafkaServer"
    Owner = var.owner
  }

  user_data = data.template_file.twitter_kafka_init_script.rendered
}
