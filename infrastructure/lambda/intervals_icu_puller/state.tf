terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/lambda/intervals_icu"
    region = "eu-central-1"   
    encrypt = true
  }
}