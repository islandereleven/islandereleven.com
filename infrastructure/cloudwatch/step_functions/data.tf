data "aws_sns_topic" "sfn_alerts" {
    name = "intervals_icu_pipeline_topic"
}

data "aws_sfn_state_machine" "intervals_icu_pipeline" {
    name = "intervals_icu_pipeline"
}