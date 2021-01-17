module "subscriber_service" {
  source = "../../terraform/lambda/subscriber-service"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
}

module "notification_service" {
  source = "../../terraform/lambda/notification-service"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
}

module "config_service" {
  source = "../../terraform/lambda/config-service"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
  s3_code_bucket = "${var.s3_code_bucket}"
}

module "invoker_service" {
  source = "../../terraform/lambda/invoker-service"
  workflow_name = "${var.workflow_name}"
  project_version = "${var.project_version}"
  step_function_arn = "${aws_sfn_state_machine.step_function.arn}"
}

module "secrets_store" {
  source = "../../terraform/secret_manager/subscriber_store"
  secret_name = "${var.secret_name}"
  secret_prefix = "${var.workflow_name}/subscriber"
  tags = "${var.tags}"
}
