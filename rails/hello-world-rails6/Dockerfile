FROM ruby:2.6.2-alpine3.9

RUN apk add --update nodejs nodejs-npm yarn build-base sqlite-dev

WORKDIR /app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

COPY Gemfile* ./

RUN bundle install --without development test

COPY . .

RUN bundle exec rake assets:precompile

CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production", "-p", "3000"]
