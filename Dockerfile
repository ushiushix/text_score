FROM ruby:2.4-slim
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN apt-get update \
  && apt-get install -y make gcc sqlite3 libsqlite3-dev git \
    timidity lame fluid-soundfont-gm --no-install-recommends \
  && echo soundfont /usr/share/sounds/sf2/FluidR3_GM.sf2 > /etc/timidity/timidity.cfg \
  && bundle install --without development test \
  && apt-get purge -y make gcc libsqlite3-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && ln -sf /data/t_score_production.db ./db/t_score_production.db \
  && ln -sf /data/ts_secret config/ts_secret \
  && rm -rf log && ln -s /data/log ./log
EXPOSE 8080
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-e", "production"]
