terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend {
    
  }

  required_version = ">= 1.1.6"
}

provider "aws" {
  region =   "us-west-2"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "${var.instance_name}-ec2"
  }
}

resource "aws_instance" "second_app_server" {
  provider = aws.london
  ami           = "ami-0d729d2846a86a9e7"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.instance_name_london}-ec2"
  }
}
