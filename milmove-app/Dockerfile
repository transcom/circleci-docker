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
ARG GO_VERSION=1.23.0
ARG GO_SHA256SUM=905a297f19ead44780548933e0ff1a1b86e8327bb459e92f9c0012569f76f5e3
RUN set -ex && cd ~ \
  && curl -sSLO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

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
ARG NODE_JS_VERSION="v18.20.4"
# Pulled from https://nodejs.org/dist/v18.20.4/SHASUMS256.txt
ARG NODE_JS_SHASUM256="c4b0827dc47609d0a8379e6de6c74b3934da0b1312c733b5ebdcac16e3f1e954"

ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Remove existing node \
  && rm -rf /usr/local/bin/node /usr/local/bin/nodejs \
  && : Install LTS NodeJS v18.20.4 \
  && curl -sSLO https://nodejs.org/dist/${NODE_JS_VERSION}/node-${NODE_JS_VERSION}-linux-x64.tar.gz \
  && [ $(sha256sum node-${NODE_JS_VERSION}-linux-x64.tar.gz | cut -f1 -d' ') = ${NODE_JS_SHASUM256} ] \
  && tar -C /usr/local -xzf node-${NODE_JS_VERSION}-linux-x64.tar.gz \
  && rm -v node-${NODE_JS_VERSION}-linux-x64.tar.gz \
  # Force symbolic link override
  && ln -sf /usr/local/node-${NODE_JS_VERSION}-linux-x64/bin/* /usr/local/bin \
  && : Add Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -qq update \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends yarn entr postgresql-client \
  && : Cleanup \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER circleci

# Create GOPATH, needed for swagger, needs to be owned by circleci user
RUN mkdir -p /home/circleci/go