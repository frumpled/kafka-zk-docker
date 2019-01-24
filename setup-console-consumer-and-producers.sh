# Setup Producer:
cat << EOF > produce-as-alice.sh
bin/kafka-console-producer-alice.sh --broker-list localhost:9092 --topic test --producer.config config/producer.properties
EOF

cat << EOF > bin/kafka-console-producer-alice.sh
#!/bin/bash

if [ "x\$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx512M"
fi
exec \$(dirname \$0)/kafka-run-class.sh -Djava.security.auth.login.config=/usr/bin/kafka/alice_jaas.conf kafka.tools.ConsoleProducer "\$@"
EOF

cat << EOF > config/producer.properties
bootstrap.servers=localhost:9092

security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.key.password=required
ssl.truststore.location=/usr/bin/kafka/server.truststore.jks
ssl.truststore.password=changeit
ssl.keystore.location=/usr/bin/kafka/server.keystore.jks
ssl.keystore.password=changeit
ssl.key.password=changeit
EOF

cat << EOF > /usr/bin/kafka/alice_jaas.conf
KafkaClient {
	org.apache.kafka.common.security.scram.ScramLoginModule required
	username="alice"
	password="alice";
};
EOF


#
# Setup Consumer SASL_SSL configs
#

cat << EOF > consume-as-bob.sh 
bin/kafka-console-consumer-bob.sh --bootstrap-server localhost:9092 --topic test --consumer.config config/consumer.properties
EOF

cat << EOF > bin/kafka-console-consumer-bob.sh
#!/bin/bash

if [ "x\$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx512M"
fi

exec \$(dirname \$0)/kafka-run-class.sh -Djava.security.auth.login.config=/usr/bin/kafka/bob_jaas.conf kafka.tools.ConsoleConsumer "\$@"
EOF

cat << EOF > config/consumer.properties
group.id=bob-group

security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.client.auth=required
ssl.key.password=required
ssl.truststore.location=/usr/bin/kafka/server.truststore.jks
ssl.truststore.password=changeit
ssl.keystore.location=/usr/bin/kafka/server.keystore.jks
ssl.keystore.password=changeit
ssl.key.password=changeit
EOF

cat << EOF > /usr/bin/kafka/bob_jaas.conf
KafkaClient {
	org.apache.kafka.common.security.scram.ScramLoginModule required
	username="bob"
	password="bob";
};
EOF

chmod +x *sh bin/*sh

