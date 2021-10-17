# Name: datagen.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Security Group for Datagen Server

resource "aws_security_group" "datagen_sg" {
  name        = "${var.prefix}_datagen_sg"
  description = "Security Group for Datagen"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-datagen-sg"
    Owner = var.owner
  }
}
