resource "aws_secretsmanager_secret" "db_password" {
  name = "db_password_sm"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.admin_password

  lifecycle {
    ignore_changes = [
        secret_string
    ]
  }
}
