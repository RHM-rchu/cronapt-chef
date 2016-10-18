source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 6.0'
  gem 'rubocop',    '~> 0.27.0'
end

group :codeship do
  gem 'knife-env-diff'
  gem 'unf'
  gem 'aescrypt'
end

group :unit do
  gem 'berkshelf', '~> 4.3.0'
  gem 'chefspec',  '~> 4.6.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.7'
end

group :kitchen_docker do
  gem 'kitchen-docker', '~> 2.3.0'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.20'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'rb-fsevent'
  gem 'guard', '~> 2.4'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
end
