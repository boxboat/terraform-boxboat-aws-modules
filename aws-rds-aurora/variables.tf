variable "cluster_identifier" {
  type = string
}

variable "engine" {
  type        = string
  description = "The AWS Aurora engine to use. For instance: aurora, aurora-mysql, aurora-postgresql"
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

variable "master_password" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "The list of AWS Tags to use when creating the resources"
}

variable "subnet_ids" {
  type = list(string)
  description = "The list of subnet IDs to use for the AWS Aurora cluster"

  validation {
    condition     = length(var.subnet_ids) >= 3
    error_message = "AWS RDS Aurora needs at least 3 availability zones and therefore subnets for each zone."
  }
}

variable "backup_retention_period" {
  type = number
  description = "The AWS Aurora RDS backup retention period in days. Cannot be disabled."
  default = 1

  validation {
    condition     = var.backup_retention_period > 0
    error_message = "Please don't disable the automated backups. Define a backup retention period greater than 0."
  }
}

variable "backtrack_window" {
  type = number
  description = "The AWS Aurora RDS backtrack window in seconds. Cannot be disabled. Defaults to 24 hours."
  default = 86400

  validation {
    condition     = var.backtrack_window > 0 && var.backtrack_window < 259200
    error_message = "Please don't disable the backtrack window. Define a backtrack windows must be greater than 0 and less than 72 hours (259200 seconds)."
  }
}

variable "rds_proxy" {
  type = any

  default = { enable: false }

  description = "In preview. Working in Progress."

  validation {
    condition = (
      (can(var.rds_proxy.enable) && !var.rds_proxy.enable) ||
      (can(var.rds_proxy.enable) && var.rds_proxy.enable && can(var.rds_proxy.role_arn) && can(var.rds_proxy.secret_arn))
    )
    error_message = "`rds_proxy.role_arn` and `rds_proxy.secret_arn` are required when `rds_proxy.enable` is true."
  }
}

variable "parameter_group_family" {
  type = string
  description = "The RDS parameter group to use. For example: aurora-mysql5.7"
}

variable "enable_iam_auth" {
  type = bool
  default = false
  description = "Enable the IAM authentication through RDS Proxy. Only in use when `rds_proxy.enable` is `true`."
}

variable "security_group_ids" {
  type = list(string)
  description = "The IDs of the security groups to associate to the RDS cluster"
}