#!/bin/bash

# A quick hack to create some certs for use in a test vault setup.

set -e
cd $(dirname $0)/..
export RUNDIR=$(pwd)/runtime/ssl

# Are we installed?
type certstrap > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "certstrap not installed. If osx, try brew"
    exit 1
fi

if [ -d "$RUNDIR" ]; then
    echo "CA dir eists? rm and try again... (rm -rf $RUNDIR)"
    exit 1
fi

# Make the CA
certstrap --depot-path "$RUNDIR" \
	  init \
	  --passphrase '' \
	  -c US --st MA -l 'Boston' -o 'Snakes for Vault' \
	  --ou 'CA' \
	  --cn ca

# Make certs
for cert in localhost test1 test2 test3; do
    certstrap --depot-path "$RUNDIR" \
	      request-cert \
	      --passphrase '' \
	      -c US --st MA -l 'Boston' -o 'Snakes for Vault' \
	      --ou $cert \
	      --cn $cert \
	      --domain $cert
    
    certstrap --depot-path "$RUNDIR" sign -CA ca $cert
done
	      
