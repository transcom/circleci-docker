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
ARG GO_VERSION=1.15.2
ARG GO_SHA256SUM=b49fda1ca29a1946d6bb2a5a6982cf07ccd2aba849289508ee0f9918f6bb4552
RUN set -ex && cd ~ \
  && curl -sSLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

# install go-bindata
ARG GO_BINDATA_VERSION=3.19.0
ARG GO_BINDATA_SHA256SUM=54ca3cd7a0368a2357ffe10c1f0028480b4d6cf91e397a75300e8658c7240988
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/kevinburke/go-bindata/releases/download/v${GO_BINDATA_VERSION}/go-bindata-linux-amd64 \
  && [ $(sha256sum go-bindata-linux-amd64 | cut -f1 -d' ') = ${GO_BINDATA_SHA256SUM} ] \
  && chmod 755 go-bindata-linux-amd64 \
  && mv go-bindata-linux-amd64 /usr/local/bin/go-bindata

# install swagger
ARG SWAGGER_VERSION=0.24.0
ARG SWAGGER_SHA256SUM=50698cc3524e46c805a0a909bb417eaf84cc456dfb162dc2b4e5c6b0d7f6a508
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
  && : Add Node 12.x \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://deb.nodesource.com/node_12.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list \
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
