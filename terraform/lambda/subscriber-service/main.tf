module "lambda" {
  source = "../../base/lambda"
  project_name = "${var.project_name}"
  project_version = "${var.project_version}"
  lambda_name = "subscriber-service"
  lambda_handler = "subscriber-service.lambda_handler"
  lambda_exec_role = "${aws_iam_role.lambda_role.arn}"
  timeout = "40"
  lambda_env = {
    VERSION = "${var.project_version}"
  }
}