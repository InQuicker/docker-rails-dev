FROM ruby:2.3

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    nodejs \
    git \
    build-essential \
    chrpath \
    libssl-dev  \
    libxft-dev \
    libfontconfig1 \
    libfontconfig1-dev

ARG PHANTOM_FILE=phantomjs-2.1.1-linux-x86_64
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOM_FILE}.tar.bz2
RUN tar -xvjf ${PHANTOM_FILE}.tar.bz2 && \
  mv ${PHANTOM_FILE} /usr/local/share && \
  rm ${PHANTOM_FILE}.tar.bz2 && \
  ln -sf /usr/local/share/${PHANTOM_FILE}/bin/phantomjs /usr/local/bin

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

RUN gem install bundler
