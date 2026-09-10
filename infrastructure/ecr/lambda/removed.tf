removed {
  from = aws_ecr_repository.time_in_zone_chart

  lifecycle {
    destroy = false
  }
}
