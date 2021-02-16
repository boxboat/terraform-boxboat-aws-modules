output "secret_arn" {
  value = aws_secretsmanager_secret_version.secret_version.arn
}

output "secret_version_id" {
  value = aws_secretsmanager_secret_version.secret_version.version_id
}