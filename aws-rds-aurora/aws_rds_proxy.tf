resource "aws_db_proxy" "rds_proxy" {
  name                   = "${var.database_name}-proxy"
  engine_family          = local.rds_proxy_engine_value
  require_tls            = true
  role_arn               = var.rds_proxy.role_arn
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids

  count = var.rds_proxy.enable? "1" : "0"

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = var.enable_iam_auth? "REQUIRED": "DISABLED"
    secret_arn  = var.rds_proxy.secret_arn
  }
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  count = var.rds_proxy.enable? "1" : "0"

  db_cluster_identifier  = aws_rds_cluster.cluster.id
  db_proxy_name          = aws_db_proxy.rds_proxy[0].name
  target_group_name      = "default"
}

resource "aws_db_proxy_default_target_group" "rds_proxy_target_group" {
  db_proxy_name = aws_db_proxy.rds_proxy[0].id

  count = var.rds_proxy.enable? "1" : "0"
}