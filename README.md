# Overview

Provides a docker-compose setup for deploying Kafka + Zookeeper locally that demonstrates simple user authorization

Dockerfile has all setup required to get up and running w/ basic authorization

Has some scripts to demonstrate how to setup ACLs & produce + consume messages for a topic for different users


# Notes
Run `docker-compose exec kafka bash` to get a shell into the container running kafka and start using the provided scripts.

Scripts are in the current working directory and `bin/`
