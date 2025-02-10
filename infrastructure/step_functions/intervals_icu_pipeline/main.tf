resource "aws_sfn_state_machine" "intervals_icu_pipeline" {
  name     = "intervals_icu_pipeline"
  role_arn = aws_iam_role.sfn_exec.arn

  definition = jsonencode({
    Comment = "pipeline to push data from intervals.icu to islandereleven.com"
    StartAt = "intervals_icu_pull"
    States = {
      intervals_icu_pull = {
        Type = "Task"
        Resource = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:intervals_icu_puller_lambda_function"
        Next = "time_in_zone_chart"
      }
      time_in_zone_chart = {
        Type = "Task"
        Resource = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:time_in_zone_chart_lambda_function"
        End = true
      }
    }
  })

  logging_configuration {
    log_destination        = "${data.aws_cloudwatch_log_group.log_group_for_sfn.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
}