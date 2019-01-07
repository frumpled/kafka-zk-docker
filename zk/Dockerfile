FROM openjdk:11-jre-slim

RUN apt update && apt install -y \
	wget \
	vim
	

RUN wget "http://apache.cs.utah.edu/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz"
RUN tar zxvf *tar.gz
RUN rm *gz

COPY start-server.sh /
COPY zoo.cfg /zookeeper-3.4.13/conf/
# ENTRYPOINT ["bin/sasl-kafka-server-start.sh", "config/server.properties"]
#RUN apt install -y coreutils
RUN touch /fake-file
CMD ["tail", "-f", "/fake-file"]
#ENTRYPOINT ["./start-server.sh"]
