# CircleCI docker image to run within
FROM milmove/circleci-docker:milmove-app

# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# apt-get project dependencies
# Notes:
# - When adding apt sources do it before 'apt-get update'
ARG CACHE_APT
RUN set -ex && cd ~ \
  && : Install chrome deps via apt packages \
  && apt-get -qq update \
  && apt-get -qq -y install --no-install-recommends --no-upgrade \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatspi2.0-0 \
  libcairo2 \
  libcups2 \
  libgbm1 \
  libgdk-pixbuf2.0-0 \
  libgtk-3-0 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libxcursor1 \
  libxss1 \
  xdg-utils \
  xvfb \
  libnspr4 \
  libnss3 \
  && : Cleanup \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/*

# install chrome
# Use this Dockerfile as a base for borrowed commands:
# https://github.com/CircleCI-Public/cimg-node/blob/main/16.15/browsers/Dockerfile

RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
  && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
  && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
  "/opt/google/chrome/google-chrome" \
  && google-chrome --version

RUN CHROME_VERSION="$(google-chrome --version)" \
  && export CHROMEDRIVER_RELEASE="$(echo $CHROME_VERSION | sed 's/^Google Chrome //')" && export CHROMEDRIVER_RELEASE=${CHROMEDRIVER_RELEASE%%.*} \
  && CHROMEDRIVER_VERSION=$(curl --silent --show-error --location --fail --retry 4 --retry-delay 5 http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_RELEASE}) \
  && curl --silent --show-error --location --fail --retry 4 --retry-delay 5 --output /tmp/chromedriver_linux64.zip "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
  && cd /tmp \
  && unzip chromedriver_linux64.zip \
  && rm -rf chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin/chromedriver \
  && chmod +x /usr/local/bin/chromedriver \
  && chromedriver --version

# start xvfb automatically to avoid needing to express in circle.yml
ENV DISPLAY :99
RUN printf '#!/bin/sh\nXvfb :99 -screen 0 1280x1024x24 &\nexec "$@"\n' > /tmp/entrypoint \
  && chmod +x /tmp/entrypoint \
  && mv /tmp/entrypoint /docker-entrypoint.sh

#ENV CHROME_PATH=/opt/google/chrome

# ensure that the build agent doesn't override the entrypoint
LABEL com.circleci.preserve-entrypoint=true

USER circleci

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
