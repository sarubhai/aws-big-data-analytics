# Name: datagen.tf
# Owner: Saurav Mitra
# Description: This terraform config will create a EC2 instance for Datagen Server

# Amazon Linux AMI Filter
data "aws_ami" "datagen_linux" {
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
data "template_file" "datagen_init_script" {
  template = templatefile("${path.module}/datagen_server.sh", {
    s3_datagen_bucket_name = var.s3_datagen_bucket_name,
    data_volume_gb         = var.data_volume_gb,
  })
}


# EC2 Instance
resource "aws_instance" "datagen_server" {
  ami                    = data.aws_ami.datagen_linux.id
  instance_type          = var.datagen_instance_type
  subnet_id              = var.private_subnet_id[0]
  vpc_security_group_ids = [var.datagen_sg_id]
  key_name               = var.keypair_name
  source_dest_check      = false

  root_block_device {
    volume_size           = var.data_volume_gb + 10
    delete_on_termination = true
  }

  iam_instance_profile = var.s3_datagen_instance_profile_name

  tags = {
    Name  = "BigDataGenerator"
    Owner = var.owner
  }

  user_data = data.template_file.datagen_init_script.rendered
}
