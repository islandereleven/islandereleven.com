# locals.tf
locals {
  lambda_role_arn = aws_iam_role.lambda_exec_role.arn
}

locals {
  default_environment_variables = {
    S3_INPUT_PATH = "s3://islandereleven-data-lake/raw/activities/platform=intervals_icu/activities.parquet"
    S3_OUTPUT_PATH = "s3://islandereleven.com/data/time_in_zone_chart.json"
    LOG_LEVEL = "INFO"
  }

  environment_variables = merge(local.default_environment_variables, var.environment_variables)
}