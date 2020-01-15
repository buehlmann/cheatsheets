# OpenSSL commands

## Show server certificate
```openssl s_client -connect kafka-kafka-bootstrap:9093 -showcerts```

## Extract server certificate in pem format
```openssl s_client -connect kafka-kafka-bootstrap:9093 2>&1 < /dev/null | sed -n '/-----BEGIN/,/-----END/p'```

## Show private key
```openssl rsa -noout -text -in user.key```

## Show details of local x509 certificate file
```openssl x509 -in ca.crt -text -noout```

## Show details of remote server certificate
```openssl s_client -connect kafka-kafka-bootstrap:9093 2>/dev/null | openssl x509 -text -noout```

## Connect to remote server with provided trusted root ca
```openssl s_client -CAfile ca.crt -connect kafka-kafka-bootstrap:9093```

## Connect to remote server with provided trusted root ca and client certificate (mutual tls)
```openssl s_client -CAfile ca.crt -cert user.crt -key user.key -verify 10 -tls1_2 -state -quiet -connect kafka-kafka-bootstrap:9093```

## Convert der to pem
```openssl x509 -inform der -in cert.crt -out cert.pem```
