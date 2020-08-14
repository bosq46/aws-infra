provider "aws" {
  region = "ap-northeast-1"
}
terraform {
  backend "s3" {
    bucket  = "bosq-infra-20200619"
    key     = "httpbin/network.tfstate"
    encrypt = true
    region  = "ap-northeast-1"
  }
}