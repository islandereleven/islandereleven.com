terraform {
  backend "s3" {
    bucket = "islandereleven-terraform-state"
    key    = "islandereleven/iam/lambda"
    region = "eu-central-1"  # Replace with your desired region
    encrypt = true
  }
}