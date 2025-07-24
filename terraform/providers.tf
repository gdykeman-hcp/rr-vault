terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.1"
    }
  }
}

provider "vault" {
  address         = var.vault_address
  token           = var.vault_token
  skip_tls_verify = true
}

provider "boundary" {
  addr                   = var.boundary_config.addr
  auth_method_login_name = var.boundary_config.auth_method_login_name
  auth_method_password   = var.boundary_config.auth_method_password
}