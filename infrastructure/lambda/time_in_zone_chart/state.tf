terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/lambda/time_in_zone"
    region = "eu-central-1"
    encrypt = true
  }
}