resource "aws_ecr_repository" "garmin_puller" {
  name = "garmin-puller"
}

resource "aws_ecr_repository" "intervals_icu_puller" {
  name = "intervals-icu-puller"
}

resource "aws_ecr_repository" "chart_data_api" {
  name = "chart_data_api"
}
