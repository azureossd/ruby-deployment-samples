FROM ruby:2.7.3-slim-buster

WORKDIR /app

COPY Gemfile* ./

RUN bundle install --without development test

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
