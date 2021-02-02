terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25"
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

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  zones = [for zone in data.aws_availability_zones.azs.zone_ids: zone]
}

# Subnets need at least two availability zones
resource "aws_subnet" "db_subnets" {
  count = 3

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnets("10.0.0.0/16",8,8,8)[count.index]

  availability_zone_id = local.zones[count.index]
}

module "aws-rds-aurora-mysql" {
  source = "../../aws-rds-aurora"

  instance_count     = 2
  engine             = "aurora-mysql"
  parameter_group_family = "aurora-mysql5.7"
  cluster_identifier = "my-aurora-rds-cluster"
  availability_zones = aws_subnet.db_subnets[*].availability_zone
  instance_class     = "db.t3.small"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "barbut8chars"

  tags = {}

  subnet_ids = aws_subnet.db_subnets[*].id
}
