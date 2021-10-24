# Name: twitter.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Security Group for Twitter Server

resource "aws_security_group" "twitter_sg" {
  name        = "${var.prefix}_twitter_sg"
  description = "Security Group for Twitter"
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
    Name  = "${var.prefix}-twitter-sg"
    Owner = var.owner
  }
}
