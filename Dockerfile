ARG VARIANT=3.1
FROM ruby:${VARIANT}

# Cache buster - change it to something unique to get the apt-update to run again
ENV docker_cache_id 26july2022

# Install NodeJS
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apt-transport-https \
    && curl --silent --show-error --location https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl --silent --show-error --location https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_16.x/ bullseye main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y yarn nodejs

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    && apt-get -y install --no-install-recommends \
        ca-certificates \
        cmake \
    && gem install \
        "bundler:~>2.3.0" \
        foreman \
        rails

WORKDIR /app
ENV HOME /app

# container startup tasks
ADD config/container/boot.sh /boot.sh

# copy app
RUN mkdir -p /app
COPY . /app

# bundle install and prepare assets
RUN cd /app && bundle install
RUN cd /app && RAILS_ENV=production DATABASE_URL=sqlite3:///:memory SECRET_KEY_BASE=1 bundle exec rails assets:precompile

EXPOSE 5000
ENTRYPOINT ["/boot.sh"]
