FROM runatlantis/atlantis:v0.17.0
# This image installs this ^----- particular version of atlantis
# at /usr/local/bin/atlantis and several versions of terraform.
# See: https://github.com/runatlantis/atlantis/releases and
#      https://hub.docker.com/r/runatlantis/atlantis/tags

# Terraform version used can be controlled by setting
# DEFAULT_TERRAFORM_VERSION environment variable in the container
# See: https://github.com/runatlantis/atlantis/blob/master/Dockerfile
# for available versions

# Bust the cache before running non-repeatable commands
ARG version

# Install latest system patches
RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*

# Install Python3 for Lambdas
RUN apk add --no-cache python3

LABEL name="atlantis"
LABEL version=$version

EXPOSE 4141
