source "https://rubygems.org"
ruby "2.3.3"

gem "active_model_serializers"
gem "date_validator"
gem "devise"
gem "kaminari"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "rails", "~> 5.0.0", ">= 5.0.0.1"

# gem 'rack-cors'

group :development, :test do
  gem "byebug", platform: :mri
  gem "factory_girl_rails"
  gem "rspec-rails"
end

group :development do
  gem "awesome_print"
  gem "letter_opener"
  gem "listen", "~> 3.0.5"
  gem "pry-byebug"
  gem "pry-rails"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "shoulda-matchers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
