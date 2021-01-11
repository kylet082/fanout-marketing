output "function_name" {
  description = "lambda function name"
  value = "${aws_lambda_function.lambda.function_name}"
}

output "arn" {
  description = "lambda function ARN"
  value = "${aws_lambda_function.lambda.arn}"
}