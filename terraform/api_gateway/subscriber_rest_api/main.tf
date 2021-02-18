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
  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_resource" "invoke_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.optin_api.root_resource_id}"
  path_part   = "invoker"
}

#enable cors
resource "aws_api_gateway_method" "cors_options_method" {
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  resource_id = "${aws_api_gateway_resource.invoke_resource.id}"
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  http_method = "${aws_api_gateway_method.cors_options_method.http_method}"
  resource_id = "${aws_api_gateway_resource.invoke_resource.id}"
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = ["aws_api_gateway_method.cors_options_method"]
}

resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.optin_api.id}"
    resource_id   = "${aws_api_gateway_resource.invoke_resource.id}"
    http_method   = "${aws_api_gateway_method.cors_options_method.http_method}"
    type          = "MOCK"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_templates = {
      "application/json" = "{\"statusCode\": 200}"
    }
    depends_on = ["aws_api_gateway_method.cors_options_method"]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = "${aws_api_gateway_rest_api.optin_api.id}"
    resource_id   = "${aws_api_gateway_resource.invoke_resource.id}"
    http_method   = "${aws_api_gateway_method.cors_options_method.http_method}"
    status_code   = "${aws_api_gateway_method_response.options_200.status_code}"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

    depends_on = ["aws_api_gateway_method_response.options_200"]
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

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.optin_api.id}"
  resource_id = "${aws_api_gateway_resource.invoke_resource.id}"
  http_method = "${aws_api_gateway_method.invoke_method.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

# Lambda integration
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.invoker_lambda_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${local.account_id}:${aws_api_gateway_rest_api.optin_api.id}/*/${aws_api_gateway_method.invoke_method.http_method}${aws_api_gateway_resource.invoke_resource.path}"
}