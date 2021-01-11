module "lambda" {
  source = "../../base/lambda"
  project_name = "${var.project_name}"
  project_version = "${var.project_version}"
  lambda_name = "notification-service"
  lambda_handler = "notification-service.lambda_handler"
  lambda_exec_role = "${aws_iam_role.lambda_role.arn}"
  timeout = "10"
  lambda_env = {
    VERSION = "${var.project_version}"
    EMAIL_SNS_ARN = "${module.sns.topic_arn}"
  }
}

module "sns" {
  source = "../../base/sns"
  project_name = "${var.project_name}"
  topic_name = "email"
}