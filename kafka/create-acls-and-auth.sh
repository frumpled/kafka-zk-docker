ZOOKEEPER=zk:2181

# Give permissions to ALICE
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER} --add --allow-principal User:alice --operation All --topic test --resource-pattern-type PREFIXED

# Give permissions to BOB
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER} --add --allow-principal User:bob --operation Read --topic test
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER} --add --allow-principal User:bob --operation Read --group bob-group

# List existing ACLs:
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER} --list


# Create auth user:
bin/kafka-configs.sh --zookeeper ${ZOOKEEPER} --alter --add-config 'SCRAM-SHA-512=[password=admin]' --entity-type users --entity-name admin
bin/kafka-configs.sh --zookeeper ${ZOOKEEPER} --alter --add-config 'SCRAM-SHA-512=[password=alice]' --entity-type users --entity-name alice
bin/kafka-configs.sh --zookeeper ${ZOOKEEPER} --alter --add-config 'SCRAM-SHA-512=[password=bob]' --entity-type users --entity-name bob
