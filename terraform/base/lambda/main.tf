locals {
  lambda_dist = "${var.project_name}-${var.lambda_name}-${var.project_version}.zip"
  lambda_dist_path = "${path.module}/../../../${var.build_dir}/${local.lambda_dist}"
}

resource "aws_lambda_function" "lambda" {
  filename = "${local.lambda_dist_path}"
  function_name = "${var.project_name}-${var.lambda_name}"
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