variable "aws_region" {
  description = "AWS region for the data lake bucket."
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment for this data lake stack."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod"], var.environment)
    error_message = "The prod stack environment must be prod."
  }
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for the data lake."
  type        = string
  default     = "islandereleven-data-lake"
}
