
data "aws_lambda_function" "subscriber_service_function" {
  function_name = "${module.subscriber_service.function_name}"
}

data "aws_lambda_function" "notification_service_function" {
  function_name = "${module.notification_service.function_name}"
}

data "aws_lambda_function" "config_service_function" {
  function_name = "${module.config_service.function_name}"
}

data "aws_lambda_function" "invoker_service_function" {
  function_name = "${module.invoker_service.function_name}"
}

data "template_file" "step_function_template" {
  template = "${file("${path.module}/templates/subscription-workflow.json")}"
  vars {
    workflow_name = "${var.workflow_name}"
    email_service_arn = "${data.aws_lambda_function.notification_service_function.arn}"
    config_service_arn = "${data.aws_lambda_function.config_service_function.arn}"
    subscriber_service_arn = "${data.aws_lambda_function.subscriber_service_function.arn}"
  }
}

resource "aws_iam_role" "states_role" {
  name = "${var.workflow_name}-stepfunction_role"
  path = "/"
  assume_role_policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Action" : "sts:AssumeRole",
        "Principal": {
          "Service": [
            "states.amazonaws.com"
          ]
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "states_role_access" {
  role = "${aws_iam_role.states_role.name}"
  policy_arn = "arn:aws:iam:aws:policy/service-role/AWSLambdaRole"
}

resource "aws_sfn_state_machine" "step_function" {
  name = "${var.workflow_name}-marketing-optin-wf"
  role_arn = "${aws_iam_role.states_role.arn}"
  definition = "${data.template_file.step_function_template.rendered}"
  tags = "${var.tags}"
}
