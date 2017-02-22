#!/bin/bash

cd $(dirname $0)/..
export RUNDIR=$(pwd)/runtime
cd $RUNDIR

function hcv_root() {
    awk '/Root/{print $4}' < $RUNDIR/vault-init.txt
}
function hcv_unseal() {
    awk '/Unseal/{print $4}' < $RUNDIR/vault-init.txt
}

# Launch a server. We need this running in the background.
vault server -config=../vault-config.hcl &
vault_pid=$!

export VAULT_ADDR='https://localhost:8243'

# create a vault. And unseal it
vault init -ca-cert ssl/ca.crt -key-threshold 1 -key-shares 1 | tee $RUNDIR/vault-init.txt
vault unseal -ca-cert ssl/ca.crt $(hcv_unseal)

# login
vault auth -ca-cert ssl/ca.crt $(hcv_root)

# Setup TLS auth.
# Anything signed by the CA, will get the default policies
vault auth-enable -ca-cert ssl/ca.crt  cert
vault write -ca-cert ssl/ca.crt auth/cert/certs/snake-ca \
      display_name=snake-ca \
      policies=default \
      certificate=@ssl/ca.crt \
      ttl=3600



# Tell people something
cat <<EOF





You now have a working vault running

VAULT_ADDR=$VAULT_ADDR
-ca-cert ssl/ca.crt
Your root token is $(hcv_root)

hit return when you're ready to exit
EOF
read paused

for pid in $(jobs -p); do
    kill $pid
    echo "Waiting on pid $pid"
    wait $job
done
