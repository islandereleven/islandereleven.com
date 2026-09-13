.DEFAULT_GOAL := help

AWS_REGION ?= eu-central-1
JOB_IMAGE ?= time-in-zone-chart
PROD_ECR_REPOSITORY ?= time-in-zone-chart
STAGING_ECR_REPOSITORY ?= time-in-zone-chart-staging
STAGING_LAMBDA_FUNCTION ?= time_in_zone_chart_staging_lambda_function

ECR_REGISTRY = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
PROD_IMAGE_URI = $(ECR_REGISTRY)/$(PROD_ECR_REPOSITORY):latest
STAGING_IMAGE_URI = $(ECR_REGISTRY)/$(STAGING_ECR_REPOSITORY):latest

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: require-aws-account-id
require-aws-account-id:
	@if [ -z "$(AWS_ACCOUNT_ID)" ]; then \
		echo "Error: AWS_ACCOUNT_ID environment variable is not set."; \
		exit 1; \
	fi

.PHONY: install
install: ## Install package and test dependencies
	poetry install --with test

.PHONY: lock
lock: ## Update the Poetry lockfile
	poetry lock

.PHONY: build-job
build-job: ## Build the job Docker image
	docker build --platform=linux/arm64 -t $(JOB_IMAGE) . --no-cache
	@echo "Job image built."

.PHONY: qc
qc: ## Run local package checks
	poetry check
	poetry run pytest tests/unit/ -v

.PHONY: push-job
push-job: require-aws-account-id test-unit build-job ## Build and push the job Docker image to AWS ECR
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)
	docker tag $(JOB_IMAGE):latest $(PROD_IMAGE_URI)
	docker push --platform=linux/arm64 $(PROD_IMAGE_URI)
	@echo "Job image pushed."

.PHONY: push-staging
push-staging: require-aws-account-id test-unit build-job ## Build and push the job Docker image to staging AWS ECR
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)
	docker tag $(JOB_IMAGE):latest $(STAGING_IMAGE_URI)
	docker push --platform=linux/arm64 $(STAGING_IMAGE_URI)
	@echo "Staging job image pushed."

.PHONY: deploy-staging
deploy-staging: require-aws-account-id ## Update the staging Lambda to the latest staging image
	aws lambda update-function-code \
		--function-name $(STAGING_LAMBDA_FUNCTION) \
		--image-uri $(STAGING_IMAGE_URI) \
		--region $(AWS_REGION)
	aws lambda wait function-updated \
		--function-name $(STAGING_LAMBDA_FUNCTION) \
		--region $(AWS_REGION)
	$(MAKE) staging-image-digest

.PHONY: release-staging
release-staging: ## Push the staging image and update the staging Lambda
	$(MAKE) push-staging
	$(MAKE) deploy-staging

.PHONY: staging-image-digest
staging-image-digest: ## Print staging ECR latest and Lambda resolved image digests
	@echo "ECR latest digest:"
	@aws ecr describe-images \
		--repository-name $(STAGING_ECR_REPOSITORY) \
		--image-ids imageTag=latest \
		--region $(AWS_REGION) \
		--query 'imageDetails[0].imageDigest' \
		--output text
	@echo "Lambda resolved image:"
	@aws lambda get-function \
		--function-name $(STAGING_LAMBDA_FUNCTION) \
		--region $(AWS_REGION) \
		--query 'Code.ResolvedImageUri' \
		--output text

.PHONY: test-unit
test-unit: ## Run unit tests
	poetry run pytest tests/unit/ -v
