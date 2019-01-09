
# Create server JAAS file:
SERVER_JAAS_FILE="config/kafka_server_jaas.conf"

echo "KafkaServer {" >> $SERVER_JAAS_FILE
echo "	org.apache.kafka.common.security.scram.ScramLoginModule required" >> $SERVER_JAAS_FILE
echo "	username=\"admin\"" >> $SERVER_JAAS_FILE
echo "	password=\"admin\"" >> $SERVER_JAAS_FILE
echo "	serviceName=\"kafka\"" >> $SERVER_JAAS_FILE
echo "	user_admin=\"admin\"" >> $SERVER_JAAS_FILE
echo "	user_alice=\"alice\"" >> $SERVER_JAAS_FILE
echo "	user_bob=\"bob\"" >> $SERVER_JAAS_FILE
echo "	user_charlie=\"charlie\";" >> $SERVER_JAAS_FILE
echo "};" >> $SERVER_JAAS_FILE
echo "Client {" >> $SERVER_JAAS_FILE
echo "	org.apache.zookeeper.server.auth.DigestLoginModule required" >> $SERVER_JAAS_FILE
echo "	username=\"admin\"" >> $SERVER_JAAS_FILE
echo "	password=\"admin\";" >> $SERVER_JAAS_FILE
echo "};" >> $SERVER_JAAS_FILE
echo "KafkaClient {" >> $SERVER_JAAS_FILE
echo "	org.apache.kafka.common.security.scram.ScramLoginModule required" >> $SERVER_JAAS_FILE
echo "	username=\"admin\"" >> $SERVER_JAAS_FILE
echo "	password=\"admin\";" >> $SERVER_JAAS_FILE
echo "};" >> $SERVER_JAAS_FILE


# Modify server-start script:
sed /exec/d bin/kafka-server-start.sh -i
echo "exec \$base_dir/kafka-run-class.sh \$EXTRA_ARGS -Djava.security.auth.login.config=\$base_dir/../${SERVER_JAAS_FILE} kafka.Kafka \"\$@\"" >> bin/kafka-server-start.sh

# Modify server.properties:
SERVER_PROPS_FILE="config/server.properties"
sed "s_localhost:2181_zk:2181_" $SERVER_PROPS_FILE -i

echo "\n\n" >> $SERVER_PROPS_FILE
echo "authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer" >> $SERVER_PROPS_FILE
echo "allow.everyone.if.no.acl.found=false" >> $SERVER_PROPS_FILE
echo "listeners=SASL_SSL://:9092" >> $SERVER_PROPS_FILE
echo "advertised.listeners=SASL_SSL://localhost:9092" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "sasl.enabled.mechanisms=SCRAM-SHA-512" >> $SERVER_PROPS_FILE
echo "sasl.mechanism=SCRAM-SHA-512" >> $SERVER_PROPS_FILE
echo "sasl.mechanism.inter.broker.protocol=SCRAM-SHA-512" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "security.protocol=SASL_SSL" >> $SERVER_PROPS_FILE
echo "security.inter.broker.protocol=SASL_SSL" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "security.protocol=SASL_SSL" >> $SERVER_PROPS_FILE
echo "security.inter.broker.protocol=SASL_SSL" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "ssl.client.auth=required" >> $SERVER_PROPS_FILE
echo "ssl.key.password=changeit" >> $SERVER_PROPS_FILE
echo "ssl.keystore.location=/server.keystore.jks" >> $SERVER_PROPS_FILE
echo "ssl.keystore.password=changeit" >> $SERVER_PROPS_FILE
echo "ssl.truststore.location=/server.truststore.jks" >> $SERVER_PROPS_FILE
echo "ssl.truststore.password=changeit" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "zookeeper.sasl.client.username=kafka" >> $SERVER_PROPS_FILE
echo "#zookeeper.set.acl=true" >> $SERVER_PROPS_FILE
echo "" >> $SERVER_PROPS_FILE
echo "super.users=User:admin;User:alice;" >> $SERVER_PROPS_FILE

#echo "advertised.host.name=localhost" >> $SERVER_PROPS_FILE
#echo "advertised.listeners=SASL_PLAINTEXT://:9092" >> $SERVER_PROPS_FILE


###
# Local Dev stuff:
###

create_jaas_file() { echo "KafkaClient {\n\torg.apache.kafka.common.security.scram.ScramLoginModule required\n\tusername=\"$1\"\n\tpassword=\"$1\";\n};" > "/$1_jaas.conf"; }
create_jaas_file alice
create_jaas_file bob

# Create console producer + consumer scripts:
cp bin/kafka-console-producer.sh bin/kafka-console-producer-alice.sh
sed /exec/d bin/kafka-console-producer-alice.sh -i
echo 'exec $(dirname $0)/kafka-run-class.sh -Djava.security.auth.login.config=/alice_jaas.conf kafka.tools.ConsoleProducer "$@"' >> bin/kafka-console-producer-alice.sh

cp bin/kafka-console-consumer.sh bin/kafka-console-consumer-bob.sh
sed -i /exec/d bin/kafka-console-consumer-bob.sh
echo 'exec $(dirname $0)/kafka-run-class.sh -Djava.security.auth.login.config=/bob_jaas.conf kafka.tools.ConsoleConsumer "$@"' >> bin/kafka-console-consumer-bob.sh

# Create consumer/producer scripts:
cp config/consumer.properties config/consumer-bob.properties
echo "group.id=bob-group" >> config/consumer-bob.properties

echo "bin/kafka-console-producer-alice.sh --broker-list localhost:9092 --topic test --producer.config config/producer.properties" > produce-as-alice.sh && chmod u+x produce-as-alice.sh
echo "bin/kafka-console-consumer-bob.sh --bootstrap-server localhost:9092 --topic test --consumer.config config/consumer.properties" > consume-as-bob.sh && chmod u+x consume-as-bob.sh

# Create client properties file:
PRODUCER_PROPS_FILE="config/producer.properties"
echo "security.protocol=SASL_SSL" >> $PRODUCER_PROPS_FILE
echo "sasl.mechanism=SCRAM-SHA-512" >> $PRODUCER_PROPS_FILE
echo "ssl.client.auth=required" >> $PRODUCER_PROPS_FILE
echo "ssl.key.password=required" >> $PRODUCER_PROPS_FILE
echo "ssl.truststore.location=/server.truststore.jks" >> $PRODUCER_PROPS_FILE
echo "ssl.truststore.password=changeit" >> $PRODUCER_PROPS_FILE
echo "ssl.keystore.location=/server.keystore.jks" >> $PRODUCER_PROPS_FILE
echo "ssl.keystore.password=changeit" >> $PRODUCER_PROPS_FILE
echo "ssl.key.password=changeit" >> $PRODUCER_PROPS_FILE
