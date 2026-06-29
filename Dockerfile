FROM ruby:3.3-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libssl-dev \
        nodejs \
        npm \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

WORKDIR /site

# Pre-install project dependencies during build
COPY Gemfile* package.json package-lock.json* ./
RUN npm install

EXPOSE 4000
