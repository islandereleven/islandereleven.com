output "ecr_repository_name" {
  description = "Name of the staging model-ranker ECR repository."
  value       = aws_ecr_repository.single_pass_parsing_model_ranker.name
}

output "ecr_repository_url" {
  description = "URL of the staging model-ranker ECR repository."
  value       = aws_ecr_repository.single_pass_parsing_model_ranker.repository_url
}
