source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem 'addressable'

# https://github.com/rest-client/rest-client
gem 'rest-client'

# https://github.com/typhoeus/typhoeus
gem 'typhoeus'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# ユーザー認証機能を設定 https://github.com/heartcombo/devise
gem 'devise'

# TwitterのOAuth認証のため https://github.com/omniauth/omniauth
gem 'omniauth', '1.9.1'

# CSRF トークン検証のため https://github.com/cookpad/omniauth-rails_csrf_protection
gem "omniauth-rails_csrf_protection"

# OmniAuthとTwitterを繋げるもの https://github.com/arunagw/omniauth-twitter
gem 'omniauth-twitter'

#  画像アップロードのため https://github.com/carrierwaveuploader/carrierwave
gem 'carrierwave', '~> 3.0'

# AWS S3との連携のため https://github.com/fog/fog-aws
gem 'fog-aws'

# アイコンのため https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass'

#  画像処理のため https://github.com/minimagick/minimagick
gem "mini_magick"

# 日本語化のため https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 7.0.0'

# 環境変数を扱うため https://github.com/bkeepers/dotenv
gem 'dotenv-rails', groups: [:development, :test]

# いいねを押すためのgem
gem "x", "~> 0.14.1"

gem 'twitter'
# https://github.com/jnunemaker/httparty
gem 'httparty', '>= 0.16.2'

# https://github.com/flori/json
# gem 'json', '>= 2.3.0'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end



