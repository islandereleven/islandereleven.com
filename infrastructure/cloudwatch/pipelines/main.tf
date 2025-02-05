resource "aws_cloudwatch_log_group" "log_group_for_sfn" {
  name              = "/aws/vendedlogs/states/intervals_icu_pipeline"
  retention_in_days = 30
}

# infrastructure/cloudwatch/pipelines/step_function_failure_alarm.tf
resource "aws_cloudwatch_metric_alarm" "step_function_failure" {
  alarm_name          = "StepFunctionFailure-${aws_sfn_state_machine.your_state_machine.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ExecutionsFailed"
  namespace           = "AWS/States"
  period              = 60 # Check every 60 seconds
  statistic           = "Sum"
  threshold           = 1  # Alert on ≥1 failure
  alarm_description   = "Triggers when a Step Function execution fails"
  treat_missing_data  = "notBreaching" # Ignore missing data
  alarm_actions       = [aws_sns_topic.step_function_failure.arn]

  dimensions = {
    StateMachineArn = aws_sfn_state_machine.your_state_machine.arn
  }
}