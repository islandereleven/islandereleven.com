variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "chart_data_api_lambda_function"  # Use prefix variable
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda function"
  type        = string
  default     = "chart_data_api_lambda_exec_role"  # Use prefix variable
}

variable "lambda_policy_name" {
  description = "Name of the IAM policy for the Lambda function"
  type        = string
  default     = "chart_data_api_lambda_policy"  # Use prefix variable
}

variable "lambda_image_uri" {
  description = "URI of the Docker image for the Lambda function"
  type        = string
  default     = "094956248142.dkr.ecr.eu-central-1.amazonaws.com/chart_data_api:latest"
}

variable "lambda_architectures" {
  description = "Architecture for the Lambda function"
  type        = list(string)
  default     = ["arm64"]
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 40
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}
