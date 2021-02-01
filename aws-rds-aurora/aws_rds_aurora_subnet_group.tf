resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = var.subnet_ids
}