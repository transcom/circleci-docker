# CircleCI docker image to run within
FROM milmove/circleci-docker:base
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install terraform
ARG TERRAFORM_VERSION=0.13.6
ARG TERRAFORM_SHA256SUM=55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install terraform-docs
ARG TERRAFORM_DOCS_VERSION=0.12.0
ARG TERRAFORM_DOCS_SHA256SUM=980b690da542656b6380c773d9d79edb110ba88b07cf96db730c3423fd9131d8
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/segmentio/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && [ $(sha256sum terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 | cut -f1 -d' ') = ${TERRAFORM_DOCS_SHA256SUM} ] \
  && chmod 755 terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 \
  && mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 /usr/local/bin/terraform-docs

# install tfsec
ARG TFSEC_VERSION=0.39.10
ARG TFSEC_SHA256SUM=ca56772425e9c3c5e17107b0e3e50c21df07b17a2c4a6a5af0f4d2e70150ed8d
RUN set -ex && cd ~ \
  && curl -sSLO https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 \
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
