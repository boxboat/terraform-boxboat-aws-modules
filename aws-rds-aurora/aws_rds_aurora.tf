resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-${count.index}"
  instance_class     = var.instance_class
  cluster_identifier = aws_rds_cluster.cluster.id
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  db_parameter_group_name = aws_db_parameter_group.rds_instance_parameter_group.id
 
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

  //storage is always encrypted
  storage_encrypted = true

  skip_final_snapshot = true

  //backups are enabled by default
  backup_retention_period = var.backup_retention_period

  //Backtracking window is disabled by default. 
  //Changing the backtrack window to greater than 0 enables the feature.
  backtrack_window = var.backtrack_window

  db_subnet_group_name = aws_db_subnet_group.subnet_group.id
}
