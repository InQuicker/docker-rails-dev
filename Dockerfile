FROM ruby:2.3-alpine

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  git \
  bash \
  nodejs \
  libxml2-dev libxslt-dev \
  linux-headers \
  && rm -rf /var/cache/apk/*

RUN curl -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 \
  | tar xjC /

  # zcat phantomjs-1.9.8-linux-x86_64.tar.bz2 | tar -xzf - && \
  # cp phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
  # rm -r phantomjs-1.9.8-linux-x86_64 phantomjs-1.9.8-linux-x86_64.tar.bz2

RUN curl -LOs http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
  gunzip GeoLiteCity.dat.gz && \
  mkdir -p /usr/share/GeoIP/ && \
  mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

ENV APP=/app
ENV DOCKER=true
RUN mkdir -p $APP
WORKDIR $APP

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle


RUN gem install bundler \
    && bundle config build.nokogiri --use-system-libraries

# COPY Gemfile Gemfile.lock ./
# RUN bundle install \
    # && echo "Bundle install complete"

# RUN RAILS_ENV=production bundle install --without development test --no-color --path /opt/app
# COPY . $APP

ENV PORT=3000

EXPOSE $PORT

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
