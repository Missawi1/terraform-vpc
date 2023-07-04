config {
  format = "compact"
  module = true
  force = false
  disabled_by_default = false

}

plugin "aws" {
  enabled = true
  deep_check = true
  version = "0.23.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}