provider "aws" {
  region = "AWS_REGION"
}

terraform {
  backend "s3" {
    bucket = "CODE_BUCKET"
    key = "WF_TYPE/WF_NAME/terraform/state/WF_NAME.tfstate"
    region = "AWS_REGION"
    encrypt = true
    acl = "bucket-owner-full-control"
  }
}