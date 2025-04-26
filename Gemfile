source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "devise", '~> 4.9', '>= 4.9.4' # for user authentication
# gem "acts_as_favoritable" # for likes and favorites feature
gem "aws-sdk-s3", require: false # for image uploading to AWS S3
gem "mini_magick" # for image processing
gem "image_processing" # for image processing
gem "friendly_id", '~> 5.5.1' # for user-friendly URLs
gem "devise-jwt" # for JWT authentication
gem "devise_invitable" # for user invitations
gem "devise-async" # for sending emails asynchronously
gem "kaminari" # for pagination
gem "simple_form" # for form building
gem "pundit" # for authorization
gem "better_errors" # for better error handling in development
gem "binding_of_caller" # for better error handling in development
gem "faker" # for generating fake data
gem "dotenv-rails" # for environment variables
gem "rack-cors" # for Cross-Origin Resource Sharing (CORS)
gem "oj" # for JSON parsing
gem "oj_mimic_json" # for JSON parsing
gem "redis" # for caching and background jobs
gem "sidekiq" # for background jobs
gem "sidekiq-cron" # for scheduled background jobs
gem "sidekiq-scheduler" # for scheduled background jobs
# gem "ahoy_matey" # for tracking user activity

# Use Active Record without migrations [
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "kaminari-activerecord" # for pagination with ActiveRecord

# Add HTTP asset caching, compression, and X-Sendfile acceleration to Puma for improved performance and optimized asset delivery [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "public_activity"
gem "gravatar_image_tag"
gem "active_storage_validations"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
end

group :development do
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
