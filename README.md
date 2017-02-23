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

# Policy Management

There are _at least_ two different ways to configure vault. One of
them is the nascent terraform
[vault provider](https://www.terraform.io/docs/providers/vault/index.html). There
is also an api based
[blog post](https://www.hashicorp.com/blog/codifying-vault-policies-and-configuration.html),
and associated
[repo](https://github.com/hashicorp/vault-provision-example).



## Terraform

Note that in a terraform policy `policy` and `capabilities` are
similar. `policy` is a legacy shorthand for specifying a set of
`capabilities`.

Terraform seems unable to handle anything created outside it's state
file. This has pros and cons. The big pro, is that it means it won't
delete secrets it did not create. (yay!). The big con, is that is
cannot remove or highlite configuration that was created outside
itself.

The syntax inside terraform is cumbersome. Objects are represented via
string encoded json or hcl. 

```
cd terraform
terraform plan
terraform apply
```

## API Driven Configs

