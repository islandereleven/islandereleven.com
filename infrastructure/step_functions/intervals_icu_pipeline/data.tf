data "aws_cloudwatch_log_group" "log_group_for_sfn" {
    name = "/aws/states/intervals_icu_pipeline"
}