
# Give permissions to ALICE
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:alice --operation Write --topic test --resource-pattern-type PREFIXED

# Give permissions to BOB
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:bob --operation Read --topic test
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --add --allow-principal User:bob --operation Read --group bob-group

# Give no permissions to CARLITA

# List existing ACLs
bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=zookeeper:2181 --list
