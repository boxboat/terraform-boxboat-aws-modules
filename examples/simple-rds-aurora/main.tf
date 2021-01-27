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
}