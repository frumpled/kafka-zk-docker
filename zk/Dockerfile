FROM openjdk:11-jre-slim

RUN apt update && apt install -y \
	wget \
	vim

RUN wget "http://apache.cs.utah.edu/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz"
RUN tar zxvf *tar.gz
RUN rm *gz

COPY start-server.sh /
RUN chmod +x /start-server.sh

COPY zoo.cfg /zookeeper-3.4.13/conf/
COPY java.env /zookeeper-3.4.13/conf/

COPY server_jaas.conf /

CMD ./start-server.sh && tail -f /dev/null
