terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/s3/data_lake"
    region = "eu-central-1"   
    encrypt = true
  }
}