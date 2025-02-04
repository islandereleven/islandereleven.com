resource "aws_cloudwatch_event_rule" "sfn_trigger" {
  name                = "intervals_icu_pipeline_trigger_rule"
  schedule_expression = "cron(0 2 * * ? *)"  # Example: Trigger at 12:00 PM UTC every day
}

resource "aws_cloudwatch_event_target" "sfn_target" {
  rule      = aws_cloudwatch_event_rule.sfn_trigger.name
  arn       = aws_sfn_state_machine.intervals_icu_pipeline.arn
  role_arn  = aws_iam_role.eventbridge_exec.arn
}

