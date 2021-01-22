resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "${var.cluster_identifier}-${count.index}"
  instance_class     = var.instance_class
  cluster_identifier = aws_rds_cluster.cluster.id
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier = var.cluster_identifier
  availability_zones = var.availability_zones
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
}