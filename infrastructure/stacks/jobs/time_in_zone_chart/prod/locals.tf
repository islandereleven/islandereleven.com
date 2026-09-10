locals {
  data_lake_bucket_arn = "arn:aws:s3:::${var.data_lake_bucket_name}"
  lambda_image_uri     = var.lambda_image_uri != null ? var.lambda_image_uri : "${aws_ecr_repository.time_in_zone_chart.repository_url}:${var.lambda_image_tag}"
  lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
  website_bucket_arn   = "arn:aws:s3:::${var.website_bucket_name}"

  default_environment_variables = {
    S3_INPUT_PATH  = "s3://${var.data_lake_bucket_name}/raw/activities/platform=intervals_icu/activities.parquet"
    S3_OUTPUT_PATH = "s3://${var.data_lake_bucket_name}/gold/charts/time_in_zone_chart.json"
    LOG_LEVEL      = "INFO"
  }

  environment_variables = merge(local.default_environment_variables, var.environment_variables)
}
