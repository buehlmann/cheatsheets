# OpenSSL commands

## Show server certificate
openssl s_client -connect kafka-kafka-bootstrap:9093 -showcerts

## Connect with client certificate
openssl s_client -connect kafka-kafka-bootstrap:9093 -cert client.crt

## Extract server certificate in pem format
openssl s_client -connect kafka-kafka-bootstrap:9093 2>&1 < /dev/null | sed -n '/-----BEGIN/,/-----END/p'
