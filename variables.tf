variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "tag" {
  default = {
    name = "main vpc"
  }
  description = "Tag for the resource"
  type        = map(string)
}