provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket         = "vinay-deep-s3-terraform-buvket"
    key            = "terraform/eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
  