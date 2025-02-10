terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/cloudwatch/step_functions"
    region = "eu-central-1"   
    encrypt = true
  }
}