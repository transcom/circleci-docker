# CircleCI docker image to run within
FROM cimg/node:16.15.0-browsers

# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# apt-get project dependencies
# Notes:
# - When adding apt sources do it before 'apt-get update'
#
#
# Try cimg/node browsers image
  # && : Install chrome deps via apt packages \
  # && apt-get -qq update \
  # && apt-get -qq -y install --no-install-recommends \
  #   libgtk2.0-0 \
  #   libgtk-3-0 \
  #   libgbm-dev \
  #   libnotify-dev \
  #   libgconf-2-4 \
  #   libnss3 \
  #   libxss1 \
  #   libasound2 \
  #   libxtst6 \
  #   xauth \
  #   xvfb \

# Try installing postgres and redis to see if we can run without
# remote docker
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Install postgresql-12 via apt packages \
  && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && curl -sSLf -o - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get -qq update \
  && apt-get -y install --no-install-recommends \
    postgresql-12 \
  && : Install redis via apt packages \
  && apt-get -qq -y install --no-install-recommends \
    redis-server \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

# needed to set up path for yarn and node
RUN sed -i -e "s,bin/sh,bin/bash," /docker-entrypoint.sh

# create mymove workdir
WORKDIR /home/circleci/transcom/mymove
RUN chown -R circleci:circleci /home/circleci/transcom/mymove

# create cypress workdir
WORKDIR /home/circleci/cypress
COPY milmove-cypress/package.json /home/circleci/cypress/package.json
COPY milmove-cypress/yarn.lock /home/circleci/cypress/yarn.lock

RUN chown -R circleci:circleci /home/circleci/cypress

USER circleci

RUN set -x && \
    yarn install && \
    yarn cache clean

RUN ./node_modules/.bin/cypress run || echo done

