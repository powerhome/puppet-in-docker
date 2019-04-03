FROM golang:1.12-alpine

ARG NATS_VERSION="0.9.6"
ENV DUMB_INIT_VERSION="1.2.2"

LABEL org.label-schema.vendor="VSHN AG" \
      org.label-schema.url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.name="Puppet Choria NATS Broker" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.version=$NATS_VERSION \
      org.label-schema.vcs-url="https://github.com/vshn/puppet-in-docker" \
      org.label-schema.schema-version="1.0" \
      com.puppet.dockerfile="/Dockerfile"

# 4222: Client access port
# 6222: Cluster port
# 8222: Management port
EXPOSE 4222 6222 8222

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["nats"]

COPY Dockerfile /

RUN apk add --no-cache \
      run-parts \
      ruby \
      curl \
      ca-certificates \
      wget \
      openssl \
      git \
      netcat-openbsd \
      bash

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64 && \
      chmod +x /usr/local/bin/dumb-init && \
      adduser -h /etc/nats -s /bin/sh -S -D -H nats && \
      mkdir /etc/nats && \
      chown -R nats /etc/nats && \
      mkdir -p /go/src/github.com/nats-io

RUN git clone -b "v${NATS_VERSION}" https://github.com/nats-io/gnatsd.git $GOPATH/src/github.com/nats-io/gnatsd
WORKDIR /go/src/github.com/nats-io/gnatsd
RUN CGO_ENABLED=0 go install -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/gnatsd/server.gitCommit=`git rev-parse --short HEAD`"

# Add configuration files into the image
COPY request-cert.rb /usr/local/bin
COPY nats.cfg /etc/nats/gnatsd.conf

COPY docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

