variable "secret_name" {
  type = "string"
}

variable "secret_prefix" {
  type = "string"
  default = "subscriber"
}

variable "tags" {
  type = "map"
  default = {}
}