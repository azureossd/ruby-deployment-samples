#Builder
FROM ruby:2.6.2-alpine3.9 as builder

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

RUN apk add --update nodejs nodejs-npm yarn build-base sqlite-dev

WORKDIR /app

COPY Gemfile* ./

RUN bundle install --without development test

COPY . .

RUN bundle exec rake assets:precompile

#Final Stage
FROM ruby:2.6.2-alpine3.9

RUN apk add --update sqlite-dev

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app ./

CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production", "-p", "3000"]
