.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-base
build-base: ## Build the base Docker image
	docker build --platform=linux/arm64 -t time-in-zone-chart-base ./base
	@echo "Base image built."

.PHONY: build-app
build-app: ## Build the app Docker image
	docker build --platform=linux/arm64 -t time-in-zone-chart ./app --no-cache
	@echo "App image built."

.PHONY: push-app
push-app: build-base build-app ## Build images and push the app Docker image to AWS ECR
	@if [ -z "$(AWS_ACCOUNT_ID)" ]; then \
		echo "Error: AWS_ACCOUNT_ID environment variable is not set."; \
		exit 1; \
	fi
	aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com
	docker tag time-in-zone-chart:latest $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com/time-in-zone-chart:latest
	docker push --platform=linux/arm64 $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com/time-in-zone-chart:latest
	@echo "App image pushed."

.PHONY: test-unit
test-unit: ## Run unit tests in Docker
	docker build -t time-in-zone-chart-test -f tests/Dockerfile.test .
	docker run --rm time-in-zone-chart-test pytest tests/unit/ -v
