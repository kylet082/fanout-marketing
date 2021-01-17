
output "step_function_arn" {
  value = "${aws_sfn_state_machine.step_function.id}"
}

output "api_gate_way" {
  value= "${data.aws_api_gateway_rest_api.subscriber_apigw.name}"
}