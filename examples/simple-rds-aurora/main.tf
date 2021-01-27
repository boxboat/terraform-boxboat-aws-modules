terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }

  backend "s3" {
    bucket = "terraform-states-examples"
    region = "us-east-1"
    key    = "examples/simple-rds-aurora/tf.state"
  }
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "random_pet" "vpc_name" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    example_name = "simple-rds-aurora"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

module "aws-rds-aurora-mysql" {
  source = "../../aws-rds-aurora"

  instance_count     = 2
  engine             = "aurora-mysql"
  cluster_identifier = "my-aurora-rds-cluster"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  instance_class     = "db.t3.small"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "barbut8chars"

  tags = {}

  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
