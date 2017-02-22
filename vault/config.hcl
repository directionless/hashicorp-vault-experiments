backend "file" {
    path = "vault/tmp/storage"
}

listener "tcp" {
    address = "127.0.0.1:8243"
    tls_disable = 0
    tls_cert_file = "ssl/tmp/localhost.crt"
    tls_key_file = "ssl/tmp/localhost.key"
}

