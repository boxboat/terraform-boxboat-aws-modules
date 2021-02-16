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

resource "null_resource" "create_password" {
  provisioner "local-exec" {
    command = "aws secretsmanager get-random-password --exclude-punctuation --password-length 16 --query RandomPassword --output text > ${data.template_file.generated_password.rendered}"
  }
}

data "template_file" "generated_password" {
  template = "${path.module}/generated_password.txt"
}

data "local_file" "generated_password" {
  filename = data.template_file.generated_password.rendered
  depends_on = [ null_resource.create_password ]
}

resource "random_id" "uuid" {
  byte_length = 1
}

resource "aws_secretsmanager_secret" "secret" {
  name = "${local.cluster_identifier}-master-password-${random_id.uuid.dec}"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = chomp(data.local_file.generated_password.content)
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
  master_password_secret_arn = aws_secretsmanager_secret_version.secret_version.arn
  master_password_secret_version_id = aws_secretsmanager_secret_version.secret_version.version_id

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