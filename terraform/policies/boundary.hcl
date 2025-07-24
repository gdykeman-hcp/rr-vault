path "auth/token/lookup-self" {
  capabilities = ["read"]
}
path "auth/token/renew-self" {
  capabilities = ["update"]
}
path "auth/token/revoke-self" {
  capabilities = ["update"]
}
path "sys/leases/renew" {
  capabilities = ["update"]
}
path "sys/leases/revoke" {
  capabilities = ["update"]
}
path "sys/capabilities-self" {
  capabilities = ["update"]
}

path "boundary-kv/*" {
  capabilities = ["list", "read"]
}

path "ssh-client-signer-boundary/*" {
  capabilities = ["read", "create", "update"]
}
path "ssh-client-signer-boundary/issue/boundary" {
  capabilities = ["read", "create", "update"]
}
path "ssh-client-signer-boundary/sign/boundary" {
  capabilities = ["read", "create", "update"]
}