module "lambda" {
  source = "../../base/lambda"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
  lambda_name = "invoker-service"
  lambda_handler = "invoker-service.lambda_handler"
  lambda_exec_role = "${aws_iam_role.lambda_role.arn}"
  timeout = "30"
  lambda_env = {
    VERSION = "${var.project_version}"
    STEP_FUNCTION_ARN = "${var.step_function_arn}"
  }
}