# locals.tf
locals {
  lambda_role_arn = aws_iam_role.lambda_exec_role.arn
}

locals {
  default_environment_variables = {
    S3_BUCKET_NAME = "islandereleven-data-lake"
    LOG_LEVEL = "INFO"
  }

  environment_variables = merge(local.default_environment_variables, var.environment_variables)
}