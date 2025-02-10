# locals.tf
locals {
  lambda_role_arn = data.aws_iam_role.lambda_execution_role.arn
}

locals {
  default_environment_variables = {
    S3_BUCKET = "islandereleven.com"
    SECRET_NAME = var.api_key
    LOG_LEVEL = "INFO"
  }

  environment_variables = merge(local.default_environment_variables, var.environment_variables)
}