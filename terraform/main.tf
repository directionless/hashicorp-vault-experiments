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

resource "vault_policy" "example" {
  name = "dev-team"

  policy = <<EOT
path "secret/my_app" {
  policy = "write"
}
EOT
}
