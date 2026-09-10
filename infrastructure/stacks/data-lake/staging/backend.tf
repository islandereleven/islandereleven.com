terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }

  backend "s3" {
    bucket  = "islandereleven-terraform-state"
    key     = "islandereleven/stacks/data-lake/staging"
    region  = "eu-central-1"
    encrypt = true
  }
}
