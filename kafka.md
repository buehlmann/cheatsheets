## cli

Producers
```
./kafka-producer-perf-test.sh --topic prefix-hello1 --producer-props bootstrap.servers=localhost:9092 --throughput 1 --print-metrics --num-records 1000 --record-size 1024
```

Consumers
```
./kafka-consumer-perf-test.sh --print-metrics --threads 1 --group group-1 --topic prefix-hello1 --broker-list localhost:9092 --timeout 1000000 --messages 1000```
```

ZooKeeper liveness
```
echo ruok | nc localhost 2181
```
