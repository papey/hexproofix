FROM ruby:3.4-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems separately for layer caching
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the rest of the app
COPY . .

# Create non-root user
RUN useradd -m hexproofix
USER hexproofix

# Run the bot using Bundler
CMD ["bundle", "exec", "ruby", "hexproofix.rb"]
