variable "workflow_name" {
  type = "string"
}

variable "s3_code_bucket" {
  type = "string"
}

variable "project_version" {
  type = "string"
}

variable "aws_region" {
  type = "string"
  default = "eu-west-1"
}

variable "tags" {
  type = "map"
}


variable "stage_name" {
  type = "string"
  default = "demo"
}
