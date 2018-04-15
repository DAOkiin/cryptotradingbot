FROM ruby:2.5.1

RUN apt update \
  && apt install -y vim \
  && adduser -u 1000 deployer \
  && mkdir /usr/src/app \
  && chown -R 1000 "$GEM_HOME" "$BUNDLE_BIN" '/usr/src/app'

USER deployer

WORKDIR /usr/src/app

EXPOSE 4000
