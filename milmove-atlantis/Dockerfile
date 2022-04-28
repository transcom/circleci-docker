FROM runatlantis/atlantis:v0.18.1
# This image installs this ^----- particular version of atlantis
# at /usr/local/bin/atlantis and several versions of terraform.
# See: https://github.com/runatlantis/atlantis/releases and
#      https://hub.docker.com/r/runatlantis/atlantis/tags

# Terraform version used can be controlled by setting
# DEFAULT_TERRAFORM_VERSION environment variable in the container
# See: https://github.com/runatlantis/atlantis/blob/master/Dockerfile
# for available versions

# Install latest system patches
RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*

# Install Python3 for Lambdas
RUN apk add --no-cache python3

LABEL name="atlantis"

ENV DEFAULT_TERRAFORM_VERSION=1.1.2
ENV GIT_CEILING_DIRECTORIES="/home/atlantis/.atlantis/repos/transcom/transcom-infrasec-com"

EXPOSE 4141
