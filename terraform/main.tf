provider "vault" {
   # This is just using the VAULT_ADDR and VAULT_CACERT environment variables
}

resource "vault_generic_secret" "example" {
  path = "secret/foo"
  data_json = <<EOT
{
  "foo":   "bar",
  "pizza": "cheese"
}
EOT
}

resource "vault_policy" "dev-team1" {
  name = "dev-team"

  policy = <<EOT
path "secret/my_app" {
  policy = "write"
}
EOT
}

resource "vault_generic_secret" "dev-team2" {
  path = "sys/policy/dev-team2"
  data_json = <<EOT
  {
    "rules": "path \"postgresql/creds/readonly\" {\n  capabilities = [\"read\"]\n}"
  }
  EOT
}
