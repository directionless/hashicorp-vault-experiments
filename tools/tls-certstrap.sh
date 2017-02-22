#!/bin/bash

# A quick hack to create some certs for use in a test vault setup.

set -e

DIR=$(dirname $0)/../ssl/tmp

# Are we installed?
type certstrap > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "certstrap not installed. If osx, try brew"
    exit 1
fi

if [ -d "$DIR" ]; then
    echo "CA dir eists? rm and try again... ($DIR)"
    exit 1
fi

CERT_INFO="-c US --st MA -l 'Boston' -o 'Snakes for Vault'"

# Make the CA
certstrap --depot-path "$DIR" \
	  init \
	  --passphrase '' \
	  -c US --st MA -l 'Boston' -o 'Snakes for Vault' \
	  --ou 'CA' \
	  --cn ca

# Make certs
for cert in localhost test1 test2 test3; do
    certstrap --depot-path "$DIR" \
	      request-cert \
	      --passphrase '' \
	      -c US --st MA -l 'Boston' -o 'Snakes for Vault' \
	      --ou $cert \
	      --cn $cert
    certstrap --depot-path "$DIR" sign -CA ca $cert
done
	      
