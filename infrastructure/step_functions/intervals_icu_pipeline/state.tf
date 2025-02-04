terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/sf/intervals_icu_pipeline"
    region = "eu-central-1"   
    encrypt = true
  }
}