# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {
    required_version = ">= 0.14"

    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "3.0.1-rc4"
        }
    }
}

variable "proxmox_api_url" {
    type = string
    description = "Proxmox API URL"
}

variable "proxmox_api_token_id" {
    type = string
    description = "Proxmox API Token ID"
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    description = "Proxmox API Token Secret"
    sensitive = true
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
}
