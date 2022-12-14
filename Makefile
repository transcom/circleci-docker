.PHONY: help
help: ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the docker images
	@./build

.PHONY: build-arm
build-arm: ## Build the docker images using the ARM architecture (CircleCI only)
	@./build --arm-only

.PHONY: test
test: ## Build the docker images
	@./test
