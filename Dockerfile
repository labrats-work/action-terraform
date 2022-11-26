# Container image that runs your code
FROM docker.io/labratswork/ops-images-terraform:latest

LABEL org.opencontainers.image.authors="tompisula@labrats.work"

COPY tests /tests
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]