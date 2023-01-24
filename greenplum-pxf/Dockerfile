FROM gcr.io/plaidcloud-build/greenplum-oss:latest

COPY ./ /workspace/pxf/

WORKDIR /

RUN apt-get update \
&& apt-get install -y golang-go default-jdk \
&& echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment \
&& export "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"

WORKDIR /workspace/pxf/

ENV GPHOME=/usr/local/gpdb
ENV PXF_HOME=/usr/local/pxf
ENV PXF_BASE=${HOME}/pxf-base

RUN make \
&& chown -R gpadmin:gpadmin "${GPHOME}" "${PXF_HOME}" \
&& make -C ~/workspace/pxf install
