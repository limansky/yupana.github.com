FROM ruby:2.5-alpine as builder

WORKDIR /build

RUN apk update && \
    apk add --virtual jekyll-build build-base libxml2-dev libxslt-dev && \
    bundle config build.nokogiri --use-system-libraries

COPY . /build
RUN bundle install --path vendor/bundle
RUN bundle exec jekyll build --verbose

FROM nginx:alpine
COPY --from=builder /build/_site /usr/share/nginx/html
EXPOSE 80
