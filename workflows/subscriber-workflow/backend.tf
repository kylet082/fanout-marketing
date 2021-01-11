provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "kgt-dev-code"
    key = "subscriber-workflow/optin_test_wf/terraform/state/optin_test_wf.tfstate"
    region = "eu-west-1"
    encrypt = true
    acl = "bucket-owner-full-control"
  }
}