ZOOKEEPER=zk

# Give permissions to ALICE
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER}:2181 --add --allow-principal User:alice --operation All --topic test --resource-pattern-type PREFIXED

# Give permissions to BOB
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER}:2181 --add --allow-principal User:bob --operation Read --topic test
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER}:2181 --add --allow-principal User:bob --operation Read --group bob-group

# List existing ACLs:
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=${ZOOKEEPER}:2181 --list


# Create auth user:
bin/kafka-configs.sh --zookeeper ${ZOOKEEPER}:2181 --alter --add-config 'SCRAM-SHA-512=[password=admin]' --entity-type users --entity-name admin
