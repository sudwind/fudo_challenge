FROM ruby:3.4.3-alpine

# Set environment variables
ENV RACK_ENV=production
ENV BUNDLE_WITHOUT=development:test
ENV BUNDLE_APP_CONFIG=/app/.bundle
ENV PATH=/app/vendor/bundle/ruby/3.4.3/bin:${PATH}
ENV GEM_HOME=/app/vendor/bundle/ruby/3.4.3

# Set default database configuration (can be overridden at runtime)
ENV USE_DATABASE=in_memory

ENV DB_POOL_SIZE=5
ENV DB_TIMEOUT=5

# Create app directory
WORKDIR /app

# Install system dependencies and security updates
RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base postgresql-dev && \
    rm -rf /var/cache/apk/*

# Update bundler
RUN gem update --system && \
    gem install bundler

# Create a non-root user to run the application
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app

# Copy Gemfile and install dependencies first (for better caching)
COPY --chown=appuser:appgroup Gemfile Gemfile.lock* ./

# Switch to the non-root user
USER appuser

# Install dependencies into the local bundle path
RUN bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY --chown=appuser:appgroup . .

# Expose the port the app runs on
EXPOSE 9292

# Start the application with Puma
CMD ["bundle", "exec", "rackup", "-s", "puma", "--host", "0.0.0.0", "-p", "9292"] 