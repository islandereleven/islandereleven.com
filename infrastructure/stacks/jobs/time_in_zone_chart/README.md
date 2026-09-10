# Time In Zone Chart Job Stack

This directory contains environment-specific Terraform roots for the time-in-zone chart job.

- `prod` relocates the existing Lambda stack from `infrastructure/lambda/time_in_zone_chart` and keeps the existing backend key, so the prod Lambda state does not move.
- `staging` creates the staging ECR repository and staging Lambda function wired to the staging data lake bucket.

The production ECR repository is owned by the prod job stack. The old shared `infrastructure/ecr/lambda` stack keeps a compatibility output for the repository URL, but no longer manages that repository.

The staging Lambda bootstraps from the existing production image by default because the staging ECR repo starts empty. After a staging image is pushed, set `lambda_image_uri` to the staging image URI.
