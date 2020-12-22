# ===========================
# Default: help section
# ===========================

info: intro commands
intro:
	@echo ""
	@echo "KubeToolbox by Enrise"

# ===========================
# Main commands
# ===========================

build: intro do-build-amazon do-build-azure do-build-google build-digital-ocean
build-amazon: intro do-build-amazon
build-azure: intro do-build-azure
build-google: intro do-build-google
build-digital-ocean: intro do-build-digital-ocean

test: intro do-test-amazon do-test-azure do-test-google test-digital-ocean
test-amazon: intro do-test-amazon
test-azure: intro do-test-azure
test-google: intro do-test-google
test-digital-ocean: intro do-test-digital-ocean

push: intro do-push-amazon do-push-azure do-push-google push-digital-ocean
push-amazon: intro do-push-amazon
push-azure: intro do-push-azure
push-google: intro do-push-google
push-digital-ocean: intro do-push-digital-ocean

amazon: intro do-build-amazon do-test-amazon
azure: intro do-build-azure do-test-azure
google: intro do-build-google do-test-google
digital-ocean: intro do-build-digital-ocean do-test-digital-ocean

# ===========================
# Comon recipes
# ===========================

commands:
	@echo ""
	@echo "=== Makefile commands ==="
	@echo ""
	@echo "Project commands:"
	@echo "    build     Builds the containers."
	@echo "    test      Tests the containers."
	@echo "    push      Pushes the containers to the registry."

# Build commands

do-build-amazon:
	@echo ""
	@echo "=== Build Amazon Kubernetes toolbox ==="
	@echo ""
	docker build -t enrise/kube-toolbox:amazon ./Amazon

do-build-azure:
	@echo ""
	@echo "=== Build Azure Kubernetes toolbox ==="
	@echo ""
	docker build -t enrise/kube-toolbox:azure ./Azure

do-build-google:
	@echo ""
	@echo "=== Build Google Kubernetes toolbox ==="
	@echo ""
	docker build -t enrise/kube-toolbox:google ./Google

do-build-digital-ocean:
	@echo ""
	@echo "=== Build Digital Ocean Kubernetes toolbox ==="
	@echo ""
	docker build -t enrise/kube-toolbox:digital-ocean ./DigitalOcean

# Test commands

do-test-amazon:
	@echo ""
	@echo "=== Test Amazon Kubernetes toolbox ==="
	@echo ""
	docker run --rm enrise/kube-toolbox:amazon connect-kubernetes | grep -q Usage
	docker run --rm enrise/kube-toolbox:amazon helm version 2>&1 | grep -q version.BuildInfo
	docker run --rm enrise/kube-toolbox:amazon kubectl version 2>&1 | grep -q version.Info
	docker run --rm enrise/kube-toolbox:amazon aws --version | grep -q aws-cli

do-test-azure:
	@echo ""
	@echo "=== Test Azure Kubernetes toolbox ==="
	@echo ""
	docker run --rm enrise/kube-toolbox:azure connect-kubernetes | grep -q Usage
	docker run --rm enrise/kube-toolbox:azure helm version 2>&1 | grep -q version.BuildInfo
	docker run --rm enrise/kube-toolbox:azure kubectl version 2>&1 | grep -q version.Info
	docker run --rm enrise/kube-toolbox:azure az --version | grep -q azure-cli

do-test-google:
	@echo ""
	@echo "=== Test Google Kubernetes toolbox ==="
	@echo ""
	docker run --rm enrise/kube-toolbox:google connect-kubernetes | grep -q Usage
	docker run --rm enrise/kube-toolbox:google helm version 2>&1 | grep -q version.BuildInfo
	docker run --rm enrise/kube-toolbox:google kubectl version 2>&1 | grep -q version.Info
	docker run --rm enrise/kube-toolbox:google gcloud --version 2>&1 | grep -q "Google Cloud SDK"

do-test-digital-ocean:
	@echo ""
	@echo "=== Test Digital Ocean Kubernetes toolbox ==="
	@echo ""
	docker run --rm enrise/kube-toolbox:digital-ocean connect-kubernetes | grep -q Usage
	docker run --rm enrise/kube-toolbox:digital-ocean helm version 2>&1 | grep -q version.BuildInfo
	docker run --rm enrise/kube-toolbox:digital-ocean kubectl version 2>&1 | grep -q version.Info
	docker run --rm enrise/kube-toolbox:digital-ocean doctl version 2>&1 | grep -q "doctl version"

# Push commands

do-push-amazon:
	@echo ""
	@echo "=== Push Amazon Kubernetes toolbox ==="
	@echo ""
	docker push enrise/kube-toolbox:amazon

do-push-azure:
	@echo ""
	@echo "=== Push Azure Kubernetes toolbox ==="
	@echo ""
	docker push enrise/kube-toolbox:azure

do-push-google:
	@echo ""
	@echo "=== Push Google Kubernetes toolbox ==="
	@echo ""
	docker push enrise/kube-toolbox:google

do-push-digital-ocean:
	@echo ""
	@echo "=== Push Google Kubernetes toolbox ==="
	@echo ""
	docker push enrise/kube-toolbox:digital-ocean
