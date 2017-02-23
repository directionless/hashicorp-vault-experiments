#!/usr/bin/env python

# Ugly discoveries:
#
# 1. while I can curl a "directory?list=true", I cannot do that for
# more underlying objects. eg:
#   $VAULT_ADDR/v1/sys/policy?list=true    returns the list of known policies
#   $VAULT_ADDR/v1/sys?list=true           is an error

import os
import requests
import json
import logging
import sys

def sync_file(file):
    pass

def sync_dir(dir):
    pass


def setup_session(s):
    s.headers.update({ 'X-Vault-Token': os.environ['VAULT_TOKEN'] })
    
def apiget(s, path, isdir=False):
    urlparams = {}
    if isdir is True:
        urlparams['list'] = 'true'
    
    req = s.get('/'.join([os.environ['VAULT_ADDR'], 'v1', path]),
                params = urlparams,
                verify = '../runtime/ssl/ca.crt',
    )
    return req

def preflight_check(s):
    req = apiget(s, 'sys/seal-status')
    if req.status_code != 200:
        logging.warn('Failed to get sealed status')
        sys.exit(1)

    if req.json()['sealed'] != False:
        logging.warn('Vault is sealed')
        sys.exit(1)

    treq = apiget(s, 'auth/token/lookup-self')
    if treq.status_code != 200:
        logging.warn('Unable to authenticate')
        sys.exit(1)

    
def get_dir(s, dir):
    req = apiget(s, dir, True)

    # I'm not sure what the right way to handle the non-200 entries is. So None for now?
    if req.status_code == 200:
        return req.json()['policies']

    return None

def diff_file(file):
    pass

def upload_file(file):
    pass

logging.basicConfig(level=logging.DEBUG)
logging.getLogger('requests').setLevel(logging.WARNING)



with requests.Session() as s:
    setup_session(s)
    preflight_check(s)
    
    for root, dirs, files in os.walk('data'):
        vault_path = root.replace('data', '').rstrip('/')
        logging.debug("Starting on {0}".format(vault_path))
    
        # Can we content list, and check for unknowns?
        vault_contents = get_dir(s, vault_path)
        if vault_contents is None:
            logging.info("Can't list vault path {0}".format(vault_path))
        else:
            unknown_in_vault = set(vault_contents) - set(dirs + files)
            for f in unknown_in_vault:
                unknown_path = '/'.join([vault_path, f])
                logging.warn("Unknown file in vault! {0}".format(unknown_path))

    # Okay, now let's handle the files
    
            
        
    
    #print(vault_path)
    #print(dirs)
    #print(files)
