module "secret_store_home" {
  source = "../../base/aws_secret_manager"
  secret_name = "${var.secret_name}"
  secret_prefix = "${var.secret_prefix}"
}