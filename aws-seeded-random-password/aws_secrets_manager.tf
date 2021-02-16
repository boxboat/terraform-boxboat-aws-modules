resource "null_resource" "create_password" {
  provisioner "local-exec" {
    command = "aws secretsmanager get-random-password --exclude-punctuation --password-length 16 --query RandomPassword --output text > ${data.template_file.generated_password.rendered}"
  }
}

data "template_file" "generated_password" {
  template = "${path.module}/generated_password.txt"
}

data "local_file" "generated_password" {
  filename   = data.template_file.generated_password.rendered
  depends_on = [null_resource.create_password]
}

resource "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = chomp(data.local_file.generated_password.content)
}

