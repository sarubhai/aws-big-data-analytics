# Name: metabase.tf
# Owner: Saurav Mitra
# Description: This terraform config will create a EC2 instance for Metabase Server

# Ubuntu AMI Filter
# ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026
data "aws_ami" "metabase_linux" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
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
data "template_file" "metabase_init_script" {
  template = templatefile("${path.module}/metabase_server.sh", {})
}


# EC2 Instance
resource "aws_instance" "metabase_server" {
  ami                    = data.aws_ami.metabase_linux.id
  instance_type          = var.metabase_instance_type
  subnet_id              = var.private_subnet_id[0]
  vpc_security_group_ids = [var.metabase_sg_id]
  key_name               = var.keypair_name
  source_dest_check      = false

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name  = "Metabase"
    Owner = var.owner
  }

  user_data = data.template_file.metabase_init_script.rendered
}
