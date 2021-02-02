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
    key    = "examples/simple-rds-aurora-postgres/tf.state"
  }
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  zones = [for zone in data.aws_availability_zones.azs.zone_ids : zone]
}

module "aws-rds-aurora-postgres" {
  source = "../../aws-rds-aurora"

  instance_count         = 2
  engine                 = "aurora-postgresql"
  engine_version         = "12.4"
  parameter_group_family = "aurora-postgresql12"
  cluster_identifier     = "simple-postgres-cluster"
  availability_zones     = aws_subnet.db_subnets[*].availability_zone
  instance_class         = "db.t3.medium"
  database_name          = "simplepostgres"
  master_username        = "foo"
  master_password        = var.admin_password

  security_group_ids = [aws_security_group.allow_postgres.id]

  tags = {}

  subnet_ids = aws_subnet.db_subnets[*].id
}
