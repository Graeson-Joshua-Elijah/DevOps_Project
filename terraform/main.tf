terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
  required_version = ">= 1.6.0"
}

# Azure Provider
provider "azurerm" {
  features {}
}

# 1️⃣ Data source for existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "rg-devops"
}

# 2️⃣ Data source for existing Azure Container Registry (ACR)
data "azurerm_container_registry" "acr" {
  name                = "devops123"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# 3️⃣ Data source for existing AKS Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-devops"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# 4️⃣ Kubernetes Provider (connects to your AKS cluster)
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

# 5️⃣ Kubernetes Deployment for Flask App
resource "kubernetes_deployment" "flask_app" {
  metadata {
    name = "flask-app"
    labels = {
      app = "flask-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "flask-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }

      spec {
        container {
          name  = "flask-app"
          # ✅ Uses image from ACR
          image = "${data.azurerm_container_registry.acr.login_server}/flask-app:latest"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# 6️⃣ Kubernetes Service (LoadBalancer)
resource "kubernetes_service" "flask_service" {
  metadata {
    name = "flask-service"
  }

  spec {
    selector = {
      app = "flask-app"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

# 7️⃣ Output the public IP once deployed
output "service_url" {
  description = "Public IP of the deployed Flask App"
  value       = kubernetes_service.flask_service.status[0].load_balancer[0].ingress[0].ip
}