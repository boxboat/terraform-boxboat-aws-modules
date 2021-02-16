resource "aws_rds_cluster_instance" "cluster_instances" {
  count                   = var.instance_count
  identifier              = "${var.cluster_identifier}-${count.index}"
  instance_class          = var.instance_class
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  db_parameter_group_name = aws_db_parameter_group.rds_instance_parameter_group.id

  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.subnet_group.id

  auto_minor_version_upgrade = true

  depends_on = [ aws_cloudformation_stack.cluster ]
}

resource "aws_cloudformation_stack" "cluster" {
  name = "${var.cluster_identifier}-stack"

  template_body = templatefile("${path.module}/cfn-aurora-cluster.tmpl.yml", {
    availability_zones = "[${join(", ", var.availability_zones)}]"
    backtrack_window = var.backtrack_window
    engine = var.engine
    engine_version = var.engine_version
    cluster_identifier = var.cluster_identifier
    database_name = var.database_name
    master_username = var.master_username
    master_password_secret_arn = aws_secretsmanager_secret_version.secret_version.arn
    master_password_secret_version_id = aws_secretsmanager_secret_version.secret_version.version_id
    backup_retention_period = var.backup_retention_period
    db_subnet_group_name = aws_db_subnet_group.subnet_group.id
    vpc_security_group_ids = "[${join(", ", var.security_group_ids)}]"
  })
}