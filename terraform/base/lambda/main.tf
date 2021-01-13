locals {
  lambda_dist = "deployment_package.zip"
  lambda_dist_path = "${path.root}/../../aws-components/lambda/${var.lambda_name}/${local.lambda_dist}"
}

resource "aws_lambda_function" "lambda" {
  filename = "${local.lambda_dist_path}"
  function_name = "${var.workflow_name}-${var.lambda_name}"
  role = "${var.lambda_exec_role}"
  handler = "${var.lambda_handler}"
  source_code_hash = "${base64sha256(file("${local.lambda_dist_path}"))}"
  runtime = "${var.python_runtime}"
  timeout = "${var.timeout}"

  timeouts {
    create="15m"
  }

  // TODO :  add vpc connections configs

  environment {
    variables = "${var.lambda_env}"
  }

}