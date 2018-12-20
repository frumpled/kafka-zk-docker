
# Give permissions to ALICE
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:alice --operation Write --topic test --resource-pattern-type PREFIXED

# Give permissions to BOB
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:bob --operation Read --topic test
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:bob --operation Read --group bob-group


# List
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --lis
