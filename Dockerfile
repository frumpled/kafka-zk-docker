FROM openjdk:11-jre-slim

RUN apt update && apt install -y \
	wget \
	vim
	

RUN wget "http://apache.claz.org/kafka/2.1.0/kafka_2.11-2.1.0.tgz"
RUN tar zxvf kafka*
RUN rm *tgz

WORKDIR /kafka_2.11-2.1.0
RUN sed "s_localhost:2181_zookeeper:2181_" config/server.properties -i

RUN echo "KafkaServer {" >> config/kafka_server_jaas.conf && \
	echo "   org.apache.kafka.common.security.plain.PlainLoginModule required" >> config/kafka_server_jaas.conf && \
	echo "   username=\"admin\"" >> config/kafka_server_jaas.conf && \
	echo "   password=\"admin\"" >> config/kafka_server_jaas.conf && \
	echo "   user_admin=\"admin\"" >> config/kafka_server_jaas.conf && \
	echo "   user_alice=\"alice\"" >> config/kafka_server_jaas.conf && \
	echo "   user_bob=\"bob\"" >> config/kafka_server_jaas.conf && \
	echo "   user_charlie=\"charlie\";" >> config/kafka_server_jaas.conf && \
	echo "};" >> config/kafka_server_jaas.conf

RUN cp bin/kafka-server-start.sh bin/sasl-kafka-server-start.sh && \
	sed -e 's_exec.*_exec \$base\_dir/kafka-run-class.sh \$EXTRA\_ARGS -Djava.security.auth.login.config=\$base\_dir/../config/kafka\_server\_jaas.conf kafka.Kafka "\$@"_' bin/sasl-kafka-server-start.sh -i

RUN echo "" >> config/server.properties && \
	echo "authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer" >> config/server.properties && \
	echo "listeners=SASL_PLAINTEXT://:9092" >> config/server.properties && \
	echo "security.inter.broker.protocol= SASL_PLAINTEXT" >> config/server.properties && \
	echo "sasl.mechanism.inter.broker.protocol=PLAIN" >> config/server.properties && \
	echo "sasl.enabled.mechanisms=PLAIN" >> config/server.properties && \
	echo "" >> config/server.properties && \
	echo "super.users=User:admin" >> config/server.properties

RUN echo "" >> config/kafka_client_jaas_alice.conf && \
	echo "KafkaClient {" >> config/kafka_client_jaas_alice.conf && \
	echo "  org.apache.kafka.common.security.plain.PlainLoginModule required" >> config/kafka_client_jaas_alice.conf && \
	echo "  username=\"alice\"" >> config/kafka_client_jaas_alice.conf && \
	echo "  password=\"alice\";" >> config/kafka_client_jaas_alice.conf && \
	echo "};" >> config/kafka_client_jaas_alice.conf

RUN echo "" >> config/kafka_client_jaas_bob.conf && \
	echo "KafkaClient {" >> config/kafka_client_jaas_bob.conf && \
	echo "  org.apache.kafka.common.security.plain.PlainLoginModule required" >> config/kafka_client_jaas_bob.conf && \
	echo "  username=\"bob\"" >> config/kafka_client_jaas_bob.conf && \
	echo "  password=\"bob\";" >> config/kafka_client_jaas_bob.conf && \
	echo "};" >> config/kafka_client_jaas_bob.conf

RUN echo "" >> config/kafka_client_jaas_carlita.conf && \
	echo "KafkaClient {" >> config/kafka_client_jaas_carlita.conf && \
	echo "  org.apache.kafka.common.security.plain.PlainLoginModule required" >> config/kafka_client_jaas_carlita.conf && \
	echo "  username=\"carlita\"" >> config/kafka_client_jaas_carlita.conf && \
	echo "  password=\"carlita\";" >> config/kafka_client_jaas_carlita.conf && \
	echo "};" >> config/kafka_client_jaas_carlita.conf

RUN cp bin/kafka-console-producer.sh bin/sasl-kafka-console-producer-alice.sh && \
	 sed /exec/d bin/sasl-kafka-console-producer-alice.sh -i && \
	echo 'exec $(dirname $0)/kafka-run-class.sh -Djava.security.auth.login.config=$(dirname $0)/../config/kafka_client_jaas_alice.conf kafka.tools.ConsoleProducer "$@"' >> bin/sasl-kafka-console-producer-alice.sh

RUN echo "security.protocol=SASL_PLAINTEXT" > config/client-sasl.properties && \
	echo "sasl.mechanism=PLAIN" >> config/client-sasl.properties

RUN cp config/client-sasl.properties config/consumer-bob.properties && \
	echo "group.id=bob-group" >> config/consumer-bob.properties

RUN cp bin/kafka-console-consumer.sh bin/sasl-kafka-console-consumer-bob.sh && \
	sed -i /exec/d bin/sasl-kafka-console-consumer-bob.sh && \
	echo 'exec $(dirname $0)/kafka-run-class.sh -Djava.security.auth.login.config=$(dirname $0)/../config/kafka_client_jaas_bob.conf kafka.tools.ConsoleConsumer "$@"' >> bin/sasl-kafka-console-consumer-bob.sh


#RUN bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:alice --operation All --topic test

#RUN bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:bob --operation Read --group bob-group

RUN echo "bin/sasl-kafka-server-start.sh config/server.properties" > start-server.sh && chmod u+x start-server.sh
RUN echo "bin/sasl-kafka-console-producer-alice.sh --broker-list localhost:9092 --topic test --producer.config config/client-sasl.properties" > produce-as-alice.sh && chmod u+x produce-as-alice.sh
RUN echo "bin/sasl-kafka-console-consumer-bob.sh --bootstrap-server localhost:9092 --topic test --consumer.config config/consumer-bob.properties" > consume-as-bob.sh && chmod u+x consume-as-bob.sh

COPY create-acls.sh ./

ENTRYPOINT ["bin/sasl-kafka-server-start.sh", "config/server.properties"]
