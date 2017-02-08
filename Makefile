
# Just set this everywhere.
export VAULT_ADDR='https://localhost:8243'


all:

# because this is a hack, just keep all the intermediary targets
.SECONDARY:

.PHONY: ca
ca:
	mkdir -p ssl/tmp
	cd ssl/tmp && cfssl genkey -initca ../ca.json | cfssljson -bare ca
	cfssl serve -ca-key=ssl/tmp/ca-key.pem -ca=ssl/tmp/ca.pem

ssl/tmp/%.json:
	cfssl gencert -remote 127.0.0.1:8888 -hostname=$* ssl/csr.json  > $@

ssl/tmp/%.key: ssl/tmp/%.json
	cat $< | ./tools/cfssl-key-split.rb ssl/tmp/$*


.PHONY: certs
certs: ssl/tmp/localhost.key ssl/tmp/test1.key ssl/tmp/test2.key

.PHONY:vault-server
vault-server: 
	vault server -config=vault/config.hcl


vault-init:  
	VAULT_ADDR='https://localhost:8243' vault init -ca-cert ssl/tmp/ca.pem -key-threshold 1 -key-shares 1 2>&1 | tee vault/tmp/init.txt



foo:
	vault auth -ca-cert ssl/tmp/ca.pem $(awk '/Root/{print$4}' <  vault/tmp/init.txt )
	vault auth-enable -ca-cert ssl/tmp/ca.pem  cert
	vault write -ca-cert ssl/tmp/ca.pem auth/cert/certs/demo \
	  display_name=demo \
	  policies=default \
	  certificate=@ssl/tmp/ca.pem \
	  ttl=3600


	vault auth -ca-cert ssl/tmp/ca.pem -client-key=ssl/tmp/test1.key -client-cert=ssl/tmp/test1.cert  -method=cert
	vault token-lookup -ca-cert ssl/tmp/ca.pem
