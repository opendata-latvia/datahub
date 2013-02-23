source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'

gem 'haml-rails'
gem 'simple_form'
gem 'gravatar_image_tag'

gem 'paperclip'

gem 'redis'
gem 'redis-rails'

gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'cancan'

gem 'state_machine'

gem 'redcarpet'
gem 'settingslogic'

gem 'ancestry'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem 'jquery-datatables-rails'

  gem 'quiet_assets', :group => :development
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print', :require => 'ap'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'annotate', "2.4.1.beta1"
  gem 'timecop'
end

group :development do
  gem 'guard'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'guard-rspec'
  gem 'guard-jasmine'
  gem 'guard-livereload'

  gem 'thin' # to avoid webrick warnings about missing content-length
  gem 'sprinkle', :require => false
  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
end

gem 'newrelic_rpm', :group => :production

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
