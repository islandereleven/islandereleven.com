.DEFAULT_GOAL := help  

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-base
build-base: ## Build the base Docker image
	docker build -t garmin-puller-base ./base
	@echo "Base image built."

.PHONY: build-app
build-app: ## Build the app Docker image
	docker build -t garmin-puller ./app --no-cache
	@echo "App image built."

.PHONY: push-app
push-app: build-base build-app ## Build images and push the app Docker image to AWS ECR
	@if [ -z "$(AWS_ACCOUNT_ID)" ]; then \
		echo "Error: AWS_ACCOUNT_ID environment variable is not set."; \
		exit 1; \
	fi
	aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com
	docker tag garmin-puller:latest $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com/garmin-puller:latest  # Fixed image name
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.eu-central-1.amazonaws.com/garmin-puller:latest
	@echo "App image pushed to staging."

.PHONY: test-unit

test-unit: ## Run unit tests in Docker
	docker build -t garmin-puller-test -f tests/Dockerfile.test .
	docker run --rm garmin-puller-test pytest tests/unit/ -v