terraform {
  required_providers {
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