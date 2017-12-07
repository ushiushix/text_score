source 'https://rubygems.org'

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'activesupport', '>= 3.1'
gem 'bcrypt'
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'sass'
gem 'haml'
gem 'activerecord', '~> 4.2.9', :require => "active_record"
gem 'sqlite3'
gem 'midilib'
gem 'text_sequencer', :git => 'https://github.com/ushiushix/text_sequencer.git'

# server
gem 'puma'
gem 'puma_worker_killer'

group :development do
  # Test requirements
  gem 'rr', :group => "test"
  gem 'rspec', :group => "test"
  gem 'rack-test', :require => "rack/test", :group => "test"
end

# Padrino Stable Gem
gem 'padrino', '~> 0.14.1'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end
