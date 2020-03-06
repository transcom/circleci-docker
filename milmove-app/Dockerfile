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
ARG GO_VERSION=1.14
ARG GO_SHA256SUM=08df79b46b0adf498ea9f320a0f23d6ec59e9003660b4c9c1ce8e5e2c6f823ca
RUN set -ex && cd ~ \
  && curl -sSLO https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

# install go-bindata
ARG GO_BINDATA_VERSION=3.18.0
ARG GO_BINDATA_SHA256SUM=9502a4ed4c2670bb913253acbfacc62d114846eddcb78334f9383f663a38fa5b
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v${GO_BINDATA_VERSION}/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = ${GO_BINDATA_SHA256SUM} ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install chamber
ARG CHAMBER_VERSION=2.8.0
ARG CHAMBER_SHA256SUM=4a47bd9f7fb46ba4a3871efbb60931592defe7c954bd10b4e92323aa30874fc1
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/chamber/releases/download/v${CHAMBER_VERSION}/chamber-v${CHAMBER_VERSION}-linux-amd64 \
  && [ $(sha256sum chamber-v${CHAMBER_VERSION}-linux-amd64 | cut -f1 -d' ') = ${CHAMBER_SHA256SUM} ] \
  && chmod 755 chamber-v${CHAMBER_VERSION}-linux-amd64 \
  && mv chamber-v${CHAMBER_VERSION}-linux-amd64 /usr/local/bin/chamber

# install swagger
ARG SWAGGER_VERSION=0.21.0
ARG SWAGGER_SHA256SUM=a50dd0e9db98a6bf9d0794882f24c18c57308963a05b41c44db0c5d295164949
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/go-swagger/go-swagger/releases/download/v${SWAGGER_VERSION}/swagger_linux_amd64 \
  && [ $(sha256sum swagger_linux_amd64 | cut -f1 -d' ') = ${SWAGGER_SHA256SUM} ] \
  && chmod 755 swagger_linux_amd64 \
  && ls -alh swagger_linux_amd64 \
  && mv swagger_linux_amd64 /usr/local/bin/swagger

# apt-get project dependencies
# Notes:
# - When adding apt sources do it before 'apt-get update'
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Add Node 10.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list \
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
