source 'https://rubygems.org'

#core gems
gem 'rails', '4.2.8'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'responders'

#database and server stack
gem 'unicorn', '~> 5.1'
gem 'mysql2', '>= 0.3.13', '< 0.5'

group :development, :test do
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'rails-erd'
  gem 'dotenv-rails'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
end

group :test do
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

