# hashicorp-vault-experiments
Some Hashicorp Vault Experiments

Vault looks great! Unfortunately, the dev mode doesn't support
TLS. And playing with cert auth needs TLS. So, here we are. Some
shell scripts to setup an environment.


# How to Use

This doesn't handle anything clever like resumption. (yet) so rm and
start again :)

```

./tools/tls-certstrap.sh       # Make a CA, and some test certs
rm -rf runtime/vault-storage   # No resumption for now
./tools/vault-init.sh          # Start a vault
```

# Policy Mangement

## Terraform

```
cd terraform
terraform plan
terraform apply
```
