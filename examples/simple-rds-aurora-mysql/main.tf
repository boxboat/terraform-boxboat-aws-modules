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

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  zones = [for zone in data.aws_availability_zones.azs.zone_ids : zone]
  cluster_identifier = "simple-mysql-cluster"
}

resource "random_id" "random_id" {
  byte_length = 1
}

module "aws_generated_password" {
  source = "../../aws-seeded-random-password"

  secret_name = "${local.cluster_identifier}-master-password-${random_id.random_id.dec}"
}

module "aws-rds-aurora-mysql" {
  source = "../../aws-rds-aurora"

  instance_count         = 2
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.07.2"
  parameter_group_family = "aurora-mysql5.7"
  cluster_identifier     = local.cluster_identifier
  availability_zones     = aws_subnet.db_subnets[*].availability_zone
  instance_class         = "db.t3.small"
  database_name          = "simplemysql"
  master_username        = "foo"
  master_password_secret_arn = module.aws_generated_password.secret_arn
  master_password_secret_version_id = module.aws_generated_password.secret_version_id

  security_group_ids = [aws_security_group.allow_mysql.id]

  tags = {}

  subnet_ids = aws_subnet.db_subnets[*].id
}

output "cf_id" {
  value = module.aws-rds-aurora-mysql.cf_id
}

output "cf_outputs" {
  value = module.aws-rds-aurora-mysql.cf_outputs
}