# This is a copy of the milmove-infra Docker image that can be used to allow a
# sidecar upgrade of Terraform.

# CircleCI docker image to run within
FROM milmove/circleci-docker:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install terraform
ARG TERRAFORM_VERSION=1.1.2
COPY sigs/hashicorp_pgp.key /tmp/hashicorp_pgp.key
RUN gpg --import /tmp/hashicorp_pgp.key
RUN set -ex && cd ~ \
    && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig \
    && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS \
    && gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS \
    && sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS --ignore-missing \
    && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig

# install terraform-docs
ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TERRAFORM_DOCS_SHA256SUM=328c16cd6552b3b5c4686b8d945a2e2e18d2b8145b6b66129cd5491840010182
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
  && [ $(sha256sum terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz | cut -f1 -d' ') = ${TERRAFORM_DOCS_SHA256SUM} ] \
  && tar -xzf terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz -C /usr/local/bin \
  && chmod 755 /usr/local/bin/terraform-docs

#install tfsec
ARG TFSEC_VERSION=1.28.1
ARG TFSEC_SHA256SUM=17c1bd99ebe13be77ac775651bc61f44b2b4409b4578485f1168eab8c3e97507
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 \
  && [ $(sha256sum tfsec-linux-amd64 | cut -f1 -d' ') = ${TFSEC_SHA256SUM} ] \
  && chmod 755 tfsec-linux-amd64 \
  && mv tfsec-linux-amd64 /usr/local/bin/tfsec

# install find-guardduty-user
ARG FGU_VERSION=0.0.3
ARG FGU_SHA256SUM=46ef5914b4e8761517d5cd5b181ca74f4705ae6c2a897bc820ab778aca5e8805
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/trussworks/find-guardduty-user/releases/download/v${FGU_VERSION}/find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz \
  && [ $(sha256sum find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz | cut -f1 -d' ') = ${FGU_SHA256SUM} ] \
  && tar -C /usr/local/bin -xzf find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz \
  && rm -v find-guardduty-user_${FGU_VERSION}_Linux_x86_64.tar.gz

USER circleci
