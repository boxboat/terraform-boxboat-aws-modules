
resource "aws_db_parameter_group" "rds_instance_parameter_group" {
  name   = "${var.database_name}-paramg"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = local.is_mysql_bit
    content {
      name         = "local_infile"
      value        = "0"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres_bit
    content {
      name         = "log_connections"
      value        = "on"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres_bit
    content {
      name         = "log_disconnections"
      value        = "on"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres_bit
    content {
      name         = "log_temp_files"
      value        = "0"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres_bit
    content {
      name         = "log_min_duration_statement"
      value        = "-1"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres_bit
    content {
      name         = "log_min_messages"
      value        = "warning"
      apply_method = "immediate" # apply type is dynamic
    }
  }

  dynamic "parameter" {
    for_each = var.parameter_groups
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = parameter.value["apply_method"]
    }
  }
}