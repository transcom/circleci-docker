# CircleCI docker image to run within
FROM milmove/circleci-docker:base

# Base image uses "circleci", to avoid using `sudo` run as root user
# Start as user root before the install
USER root

# Install latest system patches
RUN set -ex \
  && apt-get update && apt-get install -y \
  && rm -rf /var/lib/apt/lists/*

# install terraform
ARG TERRAFORM_VERSION=0.13.6
ARG TERRAFORM_SHA256SUM=55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Atlantis
ARG ATLANTIS_VERSION=0.15.1
ARG ATLANTIS_SHA256SUM=488044bb96d75b6e0a9993abbd83d38a1f61c8f5ecfe11d7e02d94ce0d66a94d
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/runatlantis/atlantis/releases/download/v${ATLANTIS_VERSION}/atlantis_linux_amd64.zip \
  && [ $(sha256sum atlantis_linux_amd64.zip | cut -f1 -d' ') = ${ATLANTIS_SHA256SUM} ] \
  && unzip -o atlantis_linux_amd64.zip \
  && mv atlantis /usr/local/bin \
  && rm -vf atlantis_linux_amd64.zip

LABEL name="atlantis"

# Switch to user circleci to hand it back to the base image
USER circleci

EXPOSE 4141