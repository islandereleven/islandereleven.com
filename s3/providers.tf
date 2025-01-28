provider "aws" {
  alias  = "main"
  region = "eu-central-1"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}