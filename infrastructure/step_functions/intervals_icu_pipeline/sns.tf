resource "aws_sns_topic" "sfn_alerts" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "sfn_alerts_subscription" {
  topic_arn = aws_sns_topic.sfn_alerts.arn
  protocol  = "email"
  endpoint  = var.sns_email
}