source 'https://rubygems.org'

ruby '2.4.2'

gem 'sinatra', '2.0.0'
gem 'sinatra-contrib', '2.0.0'
gem 'postmark', '1.10.0'
gem 'dotenv', '2.2.1'

source 'https://9ryw1qeUBWiPN7PsYosx@gem.fury.io/myfreecomm/' do
  gem 'receipt_parser', '0.5.0'
end

group :development do
  gem 'foreman'
  gem 'pry'
end

group :test, :development do
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
end
