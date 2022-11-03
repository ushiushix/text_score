source 'https://rubygems.org'

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
# sinatra 3.x no longer works with padrino 0.15.1
gem 'sinatra', '~> 2.0'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'activesupport', '>= 3.1'
gem 'bcrypt'
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'sass'
gem 'haml', '~> 5.0'
gem 'activerecord', '~> 7.0', :require => "active_record"
gem 'sqlite3', '~> 1.4.4'
gem 'midilib'
gem 'text_sequencer', :git => 'https://github.com/ushiushix/text_sequencer.git'
gem 'kaminari'

group :puma do
  # server
  gem 'puma'
  gem 'puma_worker_killer'
end

group :development do
  # Test requirements
  gem 'rr', :group => "test"
  gem 'rspec', :group => "test"
  gem 'rack-test', :require => "rack/test", :group => "test"
end

# Padrino Stable Gem
gem 'padrino', '~> 0.15.1'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end
