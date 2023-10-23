terraform {
  #  backend "s3" {
  #    bucket = "state_bucket"
  #    key = "path/to/bucket_key"
  #    region = "us-east-2"
  #  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "api_server" {
  ami           = "ami-0e83be366243f524a" # ubuntu-22.04 + SSD
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}