variable "aws_region" {
  description = "AWS region for the time-in-zone chart job."
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment for this job stack."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod"], var.environment)
    error_message = "The prod stack environment must be prod."
  }
}

variable "ecr_repository_name" {
  description = "Existing ECR repository name for the Lambda image."
  type        = string
  default     = "time-in-zone-chart"
}

variable "lambda_image_tag" {
  description = "Image tag to use when lambda_image_uri is not set."
  type        = string
  default     = "latest"
}

variable "lambda_image_uri" {
  description = "Full Lambda image URI. When unset, the URI is built from ecr_repository_name and lambda_image_tag."
  type        = string
  default     = null
}

variable "lambda_function_name" {
  description = "Name of the Lambda function."
  type        = string
  default     = "time_in_zone_chart_lambda_function"
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda function."
  type        = string
  default     = "time_in_zone_chart_lambda_exec_role"
}

variable "lambda_policy_name" {
  description = "Name of the IAM policy for the Lambda function."
  type        = string
  default     = "time_in_zone_chart_lambda_policy"
}

variable "lambda_architectures" {
  description = "Architecture for the Lambda function."
  type        = list(string)
  default     = ["arm64"]
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds."
  type        = number
  default     = 40
}

variable "data_lake_bucket_name" {
  description = "Data lake bucket used by the Lambda job."
  type        = string
  default     = "islandereleven-data-lake"
}

variable "website_bucket_name" {
  description = "Website bucket retained in the prod Lambda policy for parity with the existing stack."
  type        = string
  default     = "islandereleven.com"
}

variable "environment_variables" {
  description = "Environment variables to merge into the Lambda configuration."
  type        = map(string)
  default     = {}
}
