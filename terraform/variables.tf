variable "resource_group" {
  type    = string
  default = "rg-devops"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "acr_name" {
  type    = string
  default = "devops123"
}

variable "aks_name" {
  type    = string
  default = "aks-devops"
}
