FROM ruby:2.3-alpine

# mariadb-dev is a big package (226MB). It is required to compile mysql2 gem

RUN apk update && \
  apk upgrade && \
  apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    curl \
    curl-dev \
    geoip-dev \
    git \
    grep \
    libxml2 \
    linux-headers \
    mariadb-dev \
    mariadb-client \
    nodejs \
    ruby-dev \
    tzdata \
    wget \
  && rm -rf /var/cache/apk/* \
  && update-ca-certificates

ARG phantom_file=phantomjs-2.1.1-linux-x86_64
RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/${phantom_file}.tar.bz2 && \
  tar -xjf ${phantom_file}.tar.bz2 && \
  cp $phantom_file/bin/phantomjs /usr/local/bin && \
  rm -rf ${phantom_file} ${phantom_file}.tar.bz2

ARG geolite_file=GeoLiteCity.dat.gz
RUN wget -q http://geolite.maxmind.com/download/geoip/database/${geolite_file} && \
  gunzip ${geolite_file} && \
  mkdir -p /usr/share/GeoIP/ && \
  mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

ENV APP=/iqapp
ENV DOCKER=true
RUN mkdir -p $APP
# Need to set /iqapp to read write so the sync tool can work
RUN chmod a+rw $APP
WORKDIR $APP

ENV BUNDLE_GEMFILE=${APP}/Gemfile \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN gem install bundler \
    && bundle config build.nokogiri --use-system-libraries

