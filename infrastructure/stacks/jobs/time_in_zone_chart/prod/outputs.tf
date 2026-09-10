output "ecr_repository_name" {
  description = "Name of the prod ECR repository for this job."
  value       = aws_ecr_repository.time_in_zone_chart.name
}

output "ecr_repository_url" {
  description = "URL of the prod ECR repository for this job."
  value       = aws_ecr_repository.time_in_zone_chart.repository_url
}

output "lambda_function_name" {
  description = "Name of the prod Lambda function."
  value       = aws_lambda_function.my_lambda.function_name
}
