.PHONY: help
help: ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the docker images
	@./scripts/build

.PHONY: test
test: ## Test the docker images
	@./scripts/test

.PHONY: release
release: ## Release the docker images
	@./scripts/release

.PHONY: check_branch
check_branch: ## Check for reserved branch names
	@./scripts/check-branch