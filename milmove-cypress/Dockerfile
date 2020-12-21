# CircleCI docker image to run within
FROM milmove/circleci-docker:base

# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# apt-get project dependencies
# Notes:
# - When adding apt sources do it before 'apt-get update'
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Install chrome deps via apt packages \
  && apt-get -qq update \
  && apt-get -qq -y install --no-install-recommends \
    libgtk2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

WORKDIR /home/circleci
COPY package.json /home/circleci/package.json
COPY yarn.lock /home/circleci/yarn.lock

RUN chown -R circleci:circleci /home/circleci

USER circleci

RUN yarn install

CMD ["yarn cypress run"]
