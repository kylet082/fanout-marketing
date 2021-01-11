
variable "project_name" {
  type = "string"
}

variable "project_version" {
  type = "string"
}

variable "build_dir" {
  type = "string"
  default = "build"
  description = "default location of built artifacts"
}

variable "python_runtime" {
  type = "string"
  default = "python3.8"
  description = "default python runtime to build artifacts"
}

variable "lambda_exec_role" {
  type = "string"
  description = "aws role for lambda function"
}

variable "lambda_name" {
  type = "string"
  description = "lambda functios name"
}

variable "lambda_handler" {
  type = "string"
  description = "the name of entry point to the lambda function"
}

variable "timeout" {
  type = "string"
  default = "10"
  description = "time for lambda function to run TTL in sec"
}

variable "lambda_env" {
  type = "map"
  description = "Lambda function environment variables"
  default = {}
}
