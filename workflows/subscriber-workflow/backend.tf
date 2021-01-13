provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "kgt-dev-code"
    key = "subscriber-workflow/wf-test/terraform/state/wf-test.tfstate"
    region = "eu-west-1"
    encrypt = true
    acl = "bucket-owner-full-control"
  }
}