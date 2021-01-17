output "secret_name" {
  value = "${aws_secretsmanager_secret.secret_base.name}"
}
