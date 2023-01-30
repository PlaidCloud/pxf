FROM gcr.io/plaidcloud-build/greenplum-oss:latest

COPY ./ /workspace/pxf/

WORKDIR /

RUN apt-get update \
&& apt-get install -y unzip maven default-jdk curl \
    && echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment

RUN curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz \
&& tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz


WORKDIR /workspace

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV GPHOME=/usr/local/gpdb
ENV PXF_HOME=/usr/local/pxf
ENV PXF_BASE=${HOME}/pxf-base
ENV GOPATH=/usr/local/go
ENV PATH=${PATH}:/usr/local/go/bin:/usr/local/gpdb/bin/

RUN go install github.com/onsi/ginkgo/ginkgo@v1.16.5

RUN make -C /workspace/pxf

# RUN chown -R gpadmin:gpadmin "${GPHOME}" "${PXF_HOME}"

# RUN make -C /workspace/pxf install
