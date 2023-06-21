FROM ghcr.io/runatlantis/atlantis:v0.24.3
# This image installs this ^----- particular version of atlantis
# at /usr/local/bin/atlantis and several versions of terraform.
# See: https://github.com/runatlantis/atlantis/releases and
#      https://github.com/runatlantis/atlantis/pkgs/container/atlantis

# Note: https://hub.docker.com/r/runatlantis/atlantis/tags was deprecated

# Terraform version used can be controlled by setting
# DEFAULT_TERRAFORM_VERSION environment variable in the container
# See: https://github.com/runatlantis/atlantis/blob/master/Dockerfile
# for available versions

# Install latest system patches
RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && rm -rf /var/cache/apk/* \
    && git config --system --add safe.directory /home/atlantis/.atlantis/repos/transcom/transcom-infrasec-com

# Install Python3 for Lambdas
RUN apk add --no-cache python3

LABEL name="atlantis"

ENV DEFAULT_TERRAFORM_VERSION=1.5.0

EXPOSE 4141
