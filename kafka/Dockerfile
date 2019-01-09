FROM openjdk:11-jre-slim

RUN apt update && apt install -y \
	wget \
	vim

RUN wget "http://apache.claz.org/kafka/2.1.0/kafka_2.11-2.1.0.tgz"
RUN tar zxvf kafka*
RUN rm *tgz

WORKDIR /kafka_2.11-2.1.0

COPY user-data.sh ./
RUN sh user-data.sh

COPY create-acls-and-auth.sh ./

RUN touch /fake-file
CMD ["tail", "-f", "/fake-file"]
