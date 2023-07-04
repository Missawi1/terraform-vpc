terraform {
    /*required_version = "value"*/

  required_providers {
    aws = {
      version = "5.1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  /*shared_credentials_files = "~/.aws/credentials"*/
}