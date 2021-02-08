# CircleCI docker image to run within
FROM milmove/circleci-docker:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install terraform
ARG TERRAFORM_VERSION=0.12.29
ARG TERRAFORM_SHA256SUM=872245d9c6302b24dc0d98a1e010aef1e4ef60865a2d1f60102c8ad03e9d5a1d
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install terraform-docs
ARG TERRAFORM_DOCS_VERSION=0.10.1
ARG TERRAFORM_DOCS_SHA256SUM=37fa36d8340ceebf54f9eda73570ddbccb04fd0a53c133d3deae279161d941a1
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && [ $(sha256sum terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 | cut -f1 -d' ') = ${TERRAFORM_DOCS_SHA256SUM} ] \
  && chmod 755 terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 /usr/local/bin/terraform-docs

# install tfsec
ARG TFSEC_VERSION=0.27.0
ARG TFSEC_SHA256SUM=16b4ef11d64f86c91017a87db7fcba89690adb0e5c0bc47e709d324682dc1732
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 \
  && [ $(sha256sum tfsec-linux-amd64 | cut -f1 -d' ') = ${TFSEC_SHA256SUM} ] \
  && chmod 755 tfsec-linux-amd64 \
  && mv tfsec-linux-amd64 /usr/local/bin/tfsec

# install find-guardduty-user
ARG FGU_VERSION=0.0.1
ARG FGU_SHA256SUM=16ca73c9e34d7903f5541ebd99e9ad5b2a6e2f259c233a875faf7ca892d06713
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/trussworks/find-guardduty-user/releases/download/v${FGU_VERSION}/find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz \
  && [ $(sha256sum find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz | cut -f1 -d' ') = ${FGU_SHA256SUM} ] \
  && tar -C /usr/local/bin -xzf find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz \
  && rm -v find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz

USER circleci
