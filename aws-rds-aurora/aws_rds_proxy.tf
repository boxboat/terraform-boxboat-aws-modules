resource "aws_db_proxy" "rds_proxy" {
  name                   = "${var.database_name}-proxy"
  engine_family          = local.rds_proxy_engine_value
  require_tls            = true
  role_arn               = var.rds_proxy.role_arn
  vpc_subnet_ids         = var.subnet_ids

  count = var.rds_proxy.enable? "1" : "0"

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = var.enable_iam_auth? "REQUIRED": "DISABLED"
    secret_arn  = var.rds_proxy.secret_arn
  }
}

resource "aws_db_proxy_default_target_group" "rds_proxy_target_group" {
  db_proxy_name = aws_db_proxy.rds_proxy[0].name

  count = var.rds_proxy.enable? "1" : "0"

  connection_pool_config {
    connection_borrow_timeout    = 120
    init_query                   = "SET x=1, y=2"
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  count = var.rds_proxy.enable? "1" : "0"

  db_cluster_identifier  = aws_rds_cluster.cluster.id
  db_proxy_name          = aws_db_proxy.rds_proxy[0].name
  target_group_name      = aws_db_proxy_default_target_group.rds_proxy_target_group[0].db_proxy_name
}