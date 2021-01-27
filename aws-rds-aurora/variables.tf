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
}