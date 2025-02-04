output "garmin_puller_repository_url" {
  value = aws_ecr_repository.garmin_puller.repository_url
}

output "intervals_icu_puller_repository_url" {
  value = aws_ecr_repository.intervals_icu_puller.repository_url
}

output "time_in_zone_chart_repository_url" {
  value = aws_ecr_repository.time_in_zone_chart.repository_url
}