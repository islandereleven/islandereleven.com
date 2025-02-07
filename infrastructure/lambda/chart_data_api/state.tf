terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/lambda/chart_data_api"
    region = "eu-central-1"
    encrypt = true
  }
}