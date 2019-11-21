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

build: intro do-build-amazon do-build-azure do-build-google
build-amazon: intro do-build-amazon
build-azure: intro do-build-azure
build-google: intro do-build-google

push: intro do-push-amazon do-push-azure do-push-google
push-amazon: intro do-push-amazon
push-azure: intro do-push-azure
push-google: intro do-push-google

# ===========================
# Comon recipes
# ===========================

commands:
	@echo ""
	@echo "=== Makefile commands ==="
	@echo ""
	@echo "Project commands:"
	@echo "    build     Builds the containers."
	@echo "    push      Pushes the containers to the registry."

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
