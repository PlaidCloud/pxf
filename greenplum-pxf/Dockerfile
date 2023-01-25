FROM gcr.io/plaidcloud-build/greenplum-oss:latest

COPY ./ /workspace/pxf/

WORKDIR /

RUN apt-get update \
&& apt-get install -y unzip maven golang-go default-jdk \
&& echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment

WORKDIR /workspace

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV GPHOME=/usr/local/gpdb
ENV PXF_HOME=/usr/local/pxf
ENV PXF_BASE=${HOME}/pxf-base
ENV GOPATH=${HOME}/go
ENV PATH=/usr/local/go/bin:${GOPATH}/bin:/usr/local/gpdb/bin/:${PATH}

RUN go install github.com/onsi/ginkgo/ginkgo@v1.16.5

# RUN make

# RUN chown -R gpadmin:gpadmin "${GPHOME}" "${PXF_HOME}"

RUN make -C /workspace/pxf install
