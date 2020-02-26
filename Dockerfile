# CircleCI docker image to run within
FROM circleci/python:3.8-buster
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install shellcheck
ARG SHELLCHECK_VERSION=0.7.0
ARG SHELLCHECK_SHA256SUM=39c501aaca6aae3f3c7fc125b3c3af779ddbe4e67e4ebdc44c2ae5cba76c847f
RUN set -ex && cd ~ \
  && curl -sSLO https://shellcheck.storage.googleapis.com/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && [ $(sha256sum shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz | cut -f1 -d' ') = ${SHELLCHECK_SHA256SUM} ] \
  && tar xvfa shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz \
  && mv shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin \
  && rm -vrf shellcheck-v${SHELLCHECK_VERSION} shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz

# install circleci cli
ARG CIRCLECI_CLI_VERSION=0.1.5879
ARG CIRCLECI_CLI_SHA256SUM=f178ea62c781aec06267017404f87983c87f171fd0e66ef3737916246ae66dd6
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/CircleCI-Public/circleci-cli/releases/download/v${CIRCLECI_CLI_VERSION}/circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz \
  && [ $(sha256sum circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz | cut -f1 -d' ') = ${CIRCLECI_CLI_SHA256SUM} ] \
  && tar xzf circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz \
  && mv circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64/circleci /usr/local/bin \
  && chmod 755 /usr/local/bin/circleci \
  && rm -vrf circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64 circleci-cli_${CIRCLECI_CLI_VERSION}_linux_amd64.tar.gz

# install awscliv2
COPY sigs/awscliv2_pgp.key /tmp/awscliv2_pgp.key
RUN gpg --import /tmp/awscliv2_pgp.key
RUN set -ex && cd ~ \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
  && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig" -o awscliv2.sig \
  && gpg --verify awscliv2.sig awscliv2.zip \
  && unzip awscliv2.zip \
  && ./aws/install --update \
  && aws --version \
  && rm -r awscliv2.zip awscliv2.sig aws

# install pip packages
ARG CACHE_PIP
ADD ./requirements.txt /tmp/requirements.txt
RUN set -ex && cd ~ \
  && pip install -r /tmp/requirements.txt --no-cache-dir --disable-pip-version-check \
  && rm -vf /tmp/requirements.txt

# apt-get all the things
# Notes:
# - Add all apt sources first
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Install apt packages \
  && apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

USER circleci
