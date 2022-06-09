terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "devdaybucket"
    key            = "state/terraform.tfstate"
    region         = "eu-west-2"

    dynamodb_table = "terraform-lock"
    encrypt        = true
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

# s3 bucket for storing state
resource "aws_s3_bucket" "s3_example" {
  bucket = "devdaybucket"

  provider = aws.london

  tags = {
    Name = "devdaybucket"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_acl" "s3_example" {
  bucket = aws_s3_bucket.s3_example.id
  acl    = "private"

  provider = aws.london
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_example.id
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.london
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }

  provider = aws.london
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"  
  attribute {
    name = "LockID"
    type = "S"
  }

  provider = aws.london
}


