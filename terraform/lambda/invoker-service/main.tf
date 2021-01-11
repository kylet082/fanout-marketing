module "lambda" {
  source = "../../base/lambda"
  project_name = "${var.project_name}"
  project_version = "${var.project_version}"
  lambda_name = "invoker-service"
  lambda_handler = "invoker-service.lambda_handler"
  lambda_exec_role = "${aws_iam_role.lambda_role.arn}"
  timeout = "30"
  lambda_env = {
    VERSION = "${var.project_version}"
  }
}