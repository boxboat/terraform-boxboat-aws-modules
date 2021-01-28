resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-${count.index}"
  instance_class     = var.instance_class
  cluster_identifier = aws_rds_cluster.cluster.id
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
 
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.subnet_group.id

  auto_minor_version_upgrade = true

}

resource "aws_rds_cluster" "cluster" {
  engine             = var.engine
  cluster_identifier = var.cluster_identifier
  availability_zones = var.availability_zones
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password

  skip_final_snapshot = true

  //backups are enabled by default
  backup_retention_period = var.backup_retention_period

  db_subnet_group_name = aws_db_subnet_group.subnet_group.id
}
