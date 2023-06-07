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
ARG GO_VERSION=1.20.3
ARG GO_SHA256SUM=979694c2c25c735755bf26f4f45e19e64e4811d661dd07b8c010f7a8e18adfca
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
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Remove existing node \
  && rm -rf /usr/local/bin/node /usr/local/bin/nodejs \
  && : Add Node 18.13.0 \
  # This is so we can pin to specific Node versions
  # See https://github.com/nodesource/distributions/issues/33#issuecomment-337767815
  # See https://deb.nodesource.com/node_18.x/pool/main/n/nodejs/ for list of packages
  && curl -o nodejs.deb https://deb.nodesource.com/node_18.x/pool/main/n/nodejs/nodejs_18.13.0-deb-1nodesource1_amd64.deb \
  && dpkg -i ./nodejs.deb \
  && rm nodejs.deb \
  && : Add Yarn \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && : Install postgresql-12 repo \
  && sh -c 'echo "deb http://apt-archive.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg-archive main" > /etc/apt/sources.list.d/pgdg.list' \
  && curl -sSLf -o - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add  \
  && apt-get -qq update \
  && : Install pinned postgresql packages \
  && apt-get -y install --no-install-recommends \
    postgresql-client-14=14.7-1.pgdg20.04+1 \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends nodejs yarn entr \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*
USER circleci

# Create GOPATH, needed for swagger, needs to be owned by circleci user
RUN mkdir -p /home/circleci/go
