terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/api_gateway/chart_data_api"
    region = "eu-central-1"
    encrypt = true
  }
}