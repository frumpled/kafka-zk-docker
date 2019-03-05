#!/bin/bash

if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx512M"
fi

exec bin/kafka-run-class.sh \
	-Djava.security.auth.login.config=./jaas_alice.conf \
	kafka.tools.ConsoleProducer \
	--broker-list localhost:9092 \
	--topic test \
	--producer.config ./alice.properties
