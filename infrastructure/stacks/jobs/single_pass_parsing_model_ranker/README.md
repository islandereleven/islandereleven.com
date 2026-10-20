# Single-Pass Parsing Model Ranker Stack

This directory contains environment-specific Terraform roots for the single-pass parsing model ranker.

- `prod` owns the ECR repository used to publish model-ranker container images.
- `staging` owns an isolated ECR repository for pre-production images.

Both repositories are isolated from the shared Lambda ECR stack so the model ranker can be deployed and evolved independently.
