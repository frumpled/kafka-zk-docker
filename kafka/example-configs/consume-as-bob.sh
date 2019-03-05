#!/bin/bash

if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx512M"
fi

exec bin/kafka-run-class.sh \
	-Djava.security.auth.login.config=./jaas_bob.conf \
	kafka.tools.ConsoleConsumer \
	--bootstrap-server localhost:9092 \
	--topic test \
	--consumer.config ./bob.properties
