resource "aws_secretsmanager_secret" "secret" {
  name = "${var.cluster_identifier}-master-password"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = var.master_password

  lifecycle {
    ignore_changes = [
        secret_string
    ]
  }
}