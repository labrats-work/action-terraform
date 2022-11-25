# Container image that runs your code
FROM docker.io/alpine:3

LABEL org.opencontainers.image.authors="tompisula@labrats.work"

RUN apk -U upgrade
# Generic pre-req
RUN apk add curl git openssh
# Terraform
RUN apk add xorriso terraform

COPY tests /tests
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]