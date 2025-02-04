terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/lambda/garmin_puller"
    region = "eu-central-1"  # Replace with your desired region
    encrypt = true
  }
}