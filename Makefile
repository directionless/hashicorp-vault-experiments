all:

# because this is a hack, just keep all the intermediary targets
.SECONDARY:

.PHONY: ca
ca:
	mkdir -p ssl/tmp
	cd ssl/tmp && cfssl genkey -initca ../ca.json | cfssljson -bare ca
	cfssl serve  -ca-key=ssl/tmp/ca-key.pem -ca=ssl/tmp/ca.pem

ssl/tmp/%.json:
	cfssl gencert -remote 127.0.0.1:8888 -hostname=$* ssl/csr.json  > $@

ssl/tmp/%.key: ssl/tmp/%.json
	cat $< | ./tools/cfssl-key-split.rb ssl/tmp/$*


.PHONY: certs
certs: ssl/tmp/localhost.key ssl/tmp/test1.key ssl/tmp/test2.key
