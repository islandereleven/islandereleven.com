terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/ecr/lambda"
    region = "eu-central-1"   
    encrypt = true
  }
}