# modules/lambda_function/variables.tf
variable "lambda_role_name" {
  description = "The name of the IAM role for the Lambda function."
  type        = string
}

variable "lambda_policy_name" {
  description = "The name of the IAM policy for the Lambda function."
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "lambda_image_uri" {
  description = "The URI of the Lambda deployment package."
  type        = string
}

variable "lambda_architectures" {
  description = "The instruction set architecture for the Lambda function."
  type        = list(string)
  default     = ["x86_64"]
}

variable "lambda_timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it."
  type        = number
  default     = 3
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "lambda_policy_statements" {
  description = "List of policy statements for the Lambda function's IAM role."
  type        = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
}