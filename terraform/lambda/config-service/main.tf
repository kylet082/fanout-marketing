module "lambda" {
  source = "../../base/lambda"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
  lambda_name = "config-service"
  lambda_handler = "config-service.lambda_handler"
  lambda_exec_role = "${aws_iam_role.lambda_role.arn}"
  timeout = "30"
  lambda_env = {
    S3_CODE_BUCKET = "${var.s3_code_bucket}"
    VERSION = "${var.project_version}"
  }
}