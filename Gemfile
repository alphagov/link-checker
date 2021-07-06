source "https://rubygems.org"

gem "rails", "6.1.4"

gem "activerecord-import"
gem "addressable"
gem "deprecated_columns"
gem "faraday"
gem "faraday-cookie_jar"
gem "gds-sso"
gem "govuk_app_config", "4.0.0.pre.4"
gem "govuk_sidekiq"
gem "pg"
gem "plek"
gem "sidekiq-scheduler"
gem "sidekiq-unique-jobs"

group :development, :test do
  gem "byebug" # Comes standard with Rails
  gem "climate_control"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :test do
  gem "rspec-its"
  gem "rspec-sidekiq"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "listen"
  gem "web-console"
end
