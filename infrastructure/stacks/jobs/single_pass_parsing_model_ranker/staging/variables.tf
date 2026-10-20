variable "aws_region" {
  description = "AWS region for the single-pass parsing model ranker."
  type        = string
  default     = "eu-central-1"
}

variable "ecr_repository_name" {
  description = "Name of the staging ECR repository for model-ranker container images."
  type        = string
  default     = "single-pass-parsing-model-ranker-staging"
}
