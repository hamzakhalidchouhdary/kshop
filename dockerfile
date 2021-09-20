FROM ruby:3.0.1

RUN gem install rails bundler

RUN gem install rails

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ENV PORT 3000


ADD . /kshop

WORKDIR /kshop

RUN bundle install

EXPOSE $PORT

ENTRYPOINT [ "bundle", "exec" ]

CMD ["rails", "server", "s", "-b", "0.0.0.0", "bash"]