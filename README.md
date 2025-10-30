# DevOps CI/CD Project 🚀

This project demonstrates a full CI/CD pipeline using:
- **GitHub Actions** for CI/CD
- **Docker** for containerization
- **Terraform** for infrastructure provisioning (Azure)
- **Ansible** for configuration management
- **Kubernetes (AKS)** for deployment

## How it works
1. Push to GitHub → triggers GitHub Actions
2. Build → Test → Push Docker image to ACR
3. Terraform provisions ACR & AKS
4. Ansible applies manifests for deployment

## Quick start
```bash
terraform init
terraform apply
kubectl apply -f k8s/
