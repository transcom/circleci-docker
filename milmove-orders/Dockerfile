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
ARG GO_VERSION=1.15.8
ARG GO_SHA256SUM=d3379c32a90fdf9382166f8f48034c459a8cc433730bc9476d39d9082c94583b
RUN set -ex && cd ~ \
  && curl -sSLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GO_VERSION}.linux-amd64.tar.gz | cut -f1 -d' ') = ${GO_SHA256SUM} ] \
  && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm -v go${GO_VERSION}.linux-amd64.tar.gz

# install chamber
# install swagger
ARG SWAGGER_VERSION=0.22.0
ARG SWAGGER_SHA256SUM=86427338df4d71062a89684acda338ce2064c451854fd4487eb354fec280aa57
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
  && apt-get -qq update \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends entr postgresql-client \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci

# Create GOPATH, needed for swagger, needs to be owned by circleci user
RUN mkdir -p /home/circleci/go
