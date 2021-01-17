resource "aws_secretsmanager_secret" "secret_base" {
  description = "AWS secret store"
  name = "${var.secret_prefix}/${var.secret_name}"
  tags = "${var.tags}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "example" {
  name = "example"
}