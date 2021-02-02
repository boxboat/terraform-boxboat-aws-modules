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
    key    = "examples/rds-aurora-mysql-with-proxies/tf.state"
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
    example_name = "rds-aurora-mysql-with-proxies"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  db_username = "fooadmin"
  zones       = [for zone in data.aws_availability_zones.azs.zone_ids : zone]
}

# Subnets need at least two availability zones
resource "aws_subnet" "db_subnets" {
  count = 3

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnets("10.0.0.0/16", 8, 8, 8)[count.index]

  availability_zone_id = local.zones[count.index]
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "db_password"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.admin_password
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  # ingress {
  #   description = "Allow MySQL"
  #   from_port   = 0
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.vpc.cidr_block]
  # }

  tags = {
    Name = "allow_mysql"
  }
}

module "aws-rds-aurora-mysql" {
  source = "../../aws-rds-aurora"

  instance_count         = 2
  engine                 = "aurora-mysql"
  parameter_group_family = "aurora-mysql5.7"
  cluster_identifier     = "my-aurora-rds-cluster"
  availability_zones     = aws_subnet.db_subnets[*].availability_zone
  instance_class         = "db.t3.small"
  database_name          = "mydb"
  master_username        = local.db_username
  master_password        = var.admin_password

  rds_proxy = {
    enable     = true
    role_arn   = aws_iam_role.rds_proxy_role.arn
    secret_arn = aws_secretsmanager_secret.db_password.arn
  }

  tags = {}

  security_group_ids = [aws_security_group.allow_mysql.id]
  subnet_ids         = aws_subnet.db_subnets[*].id
}

output "azs" {
  value = aws_subnet.db_subnets[*].availability_zone
}

output "subnets" {
  value = aws_subnet.db_subnets[*].id
}
