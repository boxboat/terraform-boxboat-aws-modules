variable "cluster_identifier" {
  type = string
}

variable "engine" {
  type        = string
  description = "The AWS Aurora engine to use. For instance: aurora, aurora-mysql, aurora-postgresql"
}

variable "engine_version" {
  type        = string
  description = <<EOF
  The AWS database engine version to use.
  You can use `aws rds describe-db-engine-versions --query "DBEngineVersions[].ValidUpgradeTarget[?Engine=='aurora-postgresql'].EngineVersion"` to get a list
EOF
}

variable "availability_zones" {
  type = list(string)
}

variable "instance_class" {
  type        = string
  description = "The instance class"
}

variable "instance_count" {
  type        = number
  description = "The number of database instances"
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "The list of AWS Tags to use when creating the resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs to use for the AWS Aurora cluster"

  validation {
    condition     = length(var.subnet_ids) >= 3
    error_message = "AWS RDS Aurora needs at least 3 availability zones and therefore subnets for each zone."
  }
}

variable "backup_retention_period" {
  type        = number
  description = "The AWS Aurora RDS backup retention period in days. Cannot be disabled."
  default     = 1

  validation {
    condition     = var.backup_retention_period > 0
    error_message = "Please don't disable the automated backups. Define a backup retention period greater than 0."
  }
}

variable "backtrack_window" {
  type        = number
  description = "The AWS Aurora RDS backtrack window in seconds. Defaults to 0 seconds."
  default     = 0

  validation {
    condition     = var.backtrack_window >= 0 && var.backtrack_window < 259200
    error_message = "For MySQL, a backtrack window must be greater than 0 and less than 72 hours (259200 seconds)."
  }
}

variable "rds_proxy" {
  type = any

  default = { enable : false }

  description = "In preview. Working in Progress."

  validation {
    condition = (
      (can(var.rds_proxy.enable) && ! var.rds_proxy.enable) ||
      (can(var.rds_proxy.enable) && var.rds_proxy.enable && can(var.rds_proxy.role_arn) && can(var.rds_proxy.secret_arn))
    )
    error_message = "`rds_proxy.role_arn` and `rds_proxy.secret_arn` are required when `rds_proxy.enable` is true."
  }
}

variable "parameter_group_family" {
  type        = string
  description = <<EOF
  The RDS parameter group to use. For example: aurora-mysql5.7
  You can use `aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily"` to get a list.
EOF
}

variable "enable_iam_auth" {
  type        = bool
  default     = false
  description = "Enable the IAM authentication through RDS Proxy. Only in use when `rds_proxy.enable` is `true`."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups to associate to the RDS cluster"
}

variable "parameter_groups" {
  type = list(any)
  default = []
  description = "The list of additional parameter groups to pass in."
}

variable "master_password_secret_arn" {
  type = string
  description = "The ARN of the secret to use for the RDS cluster"
}

variable "master_password_secret_version_id" {
  type = string
  description = "The version id holding the master password to use for the RDS cluster"
}