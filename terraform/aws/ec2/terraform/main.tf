terraform {
  #  backend "s3" {
  #    bucket = "state_bucket"
  #    key = "path/to/bucket_key"
  #    region = "us-east-2"
  #  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.0"
    }
  }

  required_version = ">= 1.1.2"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.instance_name}-kp"
  public_key = var.ec2_public_key
}

resource "aws_security_group" "security_group" {
  name        = "${var.instance_name}-sg"
  description = "EC2 instance security group"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id
  description       = "Allow SSH from anywhere IPv4"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "api_server" {
  ami                    = "ami-0e83be366243f524a" # ubuntu-22.04 + SSD
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = var.instance_name
  }
}
