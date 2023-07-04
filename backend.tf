terraform {
  backend "s3" {
    bucket = "terraform-bucket-541264"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
