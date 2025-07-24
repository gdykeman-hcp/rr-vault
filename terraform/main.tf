# Signed SSH
resource "vault_mount" "ssh" {
  for_each = var.signed_ssh
  path     = each.value.path
  type     = "ssh"
}

resource "vault_ssh_secret_backend_ca" "ssh" {
  for_each             = vault_mount.ssh
  backend              = each.value.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ssh" {
  for_each                = vault_mount.ssh
  name                    = each.key
  backend                 = each.value.path
  key_type                = "ca"
  allow_user_certificates = true
  algorithm_signer        = "rsa-sha2-256"
  allowed_users           = "*"
  allowed_extensions      = "permit-pty,permit-port-forwarding"
  default_user            = "ec2-user"
  default_extensions = {
    "permit-pty" = ""
  }
  ttl = "1800"
}

# KV
resource "vault_mount" "boundary-kv" {
  path        = "boundary-kv"
  type        = "kv"
  options     = { version = "2" }
  description = "Boundary KV Version 2 engine mount"
}

resource "vault_kv_secret_v2" "boundary-kv-secret" {
  mount               = vault_mount.boundary-kv.path
  name                = "brokered-credential"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      db_secret  = "db_secret_value",
      app_secret = "app_secret_value"
    }
  )
  custom_metadata {
    data = {
      managed_by = "Terraform",
      function   = "Hashi-RedHat"
    }
  }
}

# Policies
resource "vault_policy" "this" {
  for_each = fileset("${path.module}/policies", "*.hcl")
  name     = trimsuffix(each.value, ".hcl")
  policy   = file("${path.module}/policies/${each.value}")
  # namespace = var.namespace
}

# Token
resource "vault_token" "boundary-token" {
  no_default_policy = true
  policies          = ["boundary"]

  renewable = true
  no_parent = true
  period    = "180m"

  metadata = {
    "purpose" = "boundary-account"
  }
}