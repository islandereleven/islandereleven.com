resource "aws_cloudwatch_log_group" "log_group_for_sfn" {
  name              = "/aws/states/intervals_icu_pipeline"
  retention_in_days = 5
}

resource "aws_cloudwatch_metric_alarm" "sfn_error_alarm" {
  alarm_name                = "intervals_icu_pipeline_error_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ExecutionsFailed"
  namespace                 = "AWS/States"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Alarm when Step Function executions fail"
  insufficient_data_actions = []

  dimensions = {
    StateMachineArn = data.aws_sfn_state_machine.intervals_icu_pipeline.arn
  }

  alarm_actions = [data.aws_sns_topic.sfn_alerts.arn]
}