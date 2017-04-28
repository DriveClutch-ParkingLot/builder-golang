FROM golang:1.8.1-alpine
MAINTAINER David Hallum <david@driveclutch.com>


ENV GOPATH=/go

RUN apk --update add \
      bash \
      git \
    && rm -rf /var/cache/apk/*

ADD go.sh /scripts/
WORKDIR /app

ENTRYPOINT ["sh", "/scripts/go.sh"]
