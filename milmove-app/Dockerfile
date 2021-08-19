# CircleCI docker image to run within
FROM milmove/circleci-docker:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# Golang env flags that limit parallel execution
# The golang default is to use the max CPUs or default to 36.
# In CircleCI 2.0 the max CPUs is 2 but golang can't get this from the environment so it defaults to 36
# This can cause build flakiness for larger projects. Setting a value here that can be overridden during execution
# may prevent others from experiencing this same problem.
ENV GOFLAGS=-p=4

# install go
ARG GO_VERSION=1.16.7
ARG GO_SHA256SUM=7fe7a73f55ba3e2285da36f8b085e5c0159e9564ef5f63ee0ed6b818ade8ef04
RUN set -ex && cd ~ \
  && curl -sSLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

# install go-bindata
ARG GO_BINDATA_VERSION=3.22.0
ARG GO_BINDATA_SHA256SUM=e5d620fef845756d4223969f847de95601e1091b577a24d7e8bf2a3edd80a804
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v${GO_BINDATA_VERSION}/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = ${GO_BINDATA_SHA256SUM} ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install swagger
ARG SWAGGER_VERSION=0.27.0
ARG SWAGGER_SHA256SUM=1ec5a44ae8bb9ffafd02a9c7b1df5a8a43c2296dece02bb8fab6f13f70007f4f
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/go-swagger/go-swagger/releases/download/v${SWAGGER_VERSION}/swagger_linux_amd64 \
  && [ $(sha256sum swagger_linux_amd64 | cut -f1 -d' ') = ${SWAGGER_SHA256SUM} ] \
  && chmod 755 swagger_linux_amd64 \
  && ls -alh swagger_linux_amd64 \
  && mv swagger_linux_amd64 /usr/local/bin/swagger

ARG ECS_SERVICE_LOGS_VERSION=0.3.0
ARG ECS_SERVICE_LOGS_SHA256SUM=2803177477bb917a19fc89f36f4972af740f80d35380cbe2c97345bb6d109f8e
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/trussworks/ecs-service-logs/releases/download/v${ECS_SERVICE_LOGS_VERSION}/ecs-service-logs_${ECS_SERVICE_LOGS_VERSION}_Linux_x86_64.tar.gz \
  && [ $(sha256sum ecs-service-logs_${ECS_SERVICE_LOGS_VERSION}_Linux_x86_64.tar.gz | cut -f1 -d' ') = ${ECS_SERVICE_LOGS_SHA256SUM} ] \
  && tar -C /usr/local/bin -xzf ecs-service-logs_${ECS_SERVICE_LOGS_VERSION}_Linux_x86_64.tar.gz \
  && rm -v ecs-service-logs_${ECS_SERVICE_LOGS_VERSION}_Linux_x86_64.tar.gz


# apt-get project dependencies
# Notes:
# - When adding apt sources do it before 'apt-get update'
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Remove existing node \
  && rm -rf /usr/local/bin/node /usr/local/bin/nodejs \
  && : Add Node 14.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://deb.nodesource.com/node_14.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list \
  && : Add Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -qq update \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends nodejs yarn entr postgresql-client \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci

# Create GOPATH, needed for swagger, needs to be owned by circleci user
RUN mkdir -p /home/circleci/go
