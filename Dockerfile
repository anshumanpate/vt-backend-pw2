# Use the official Ruby image as the base image
FROM ruby:3.0.0

# Set the working directory within the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock /app/

# Install bundler and dependencies
RUN gem install bundler && bundle install

# Copy the rest of the application files into the container
COPY . /app/

 RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
   ENTRYPOINT ["/rails/bin/docker-entrypoint" ]
# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails application server
CMD ["rails", "server", "-b", "0.0.0.0"]
