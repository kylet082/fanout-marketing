data "aws_caller_identity" "current" {}

locals {
  account_id = "${data.aws_caller_identity.current.account_id}"
}

resource "aws_api_gateway_rest_api" "optin_api" {
  name        = "${var.workflow_name}-${var.project_version}-optin-api"
  description = ""

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "optin_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  stage_name  = "${var.stage}"
}

resource "aws_api_gateway_resource" "invoke_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.optin_api.root_resource_id}"
  path_part   = "invoker"
}

resource "aws_api_gateway_method" "invoke_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.optin_api.id}"
  resource_id   = "${aws_api_gateway_resource.invoke_resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.optin_api.id}"
  resource_id             = "${aws_api_gateway_resource.invoke_resource.id}"
  http_method             = "${aws_api_gateway_method.invoke_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.lambda_invoke_arn}"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.invoker_lambda_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${local.account_id}:${aws_api_gateway_rest_api.optin_api.id}/*/${aws_api_gateway_method.invoke_method.http_method}${aws_api_gateway_resource.invoke_resource.path}"
}