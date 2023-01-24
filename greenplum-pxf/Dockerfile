FROM gcr.io/plaidcloud-build/greenplum-oss:latest

COPY ./ /pxf/

WORKDIR /

RUN apt-get update \
&& apt-get install -y golang-go default-jdk \
&& echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment \
&& export "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
