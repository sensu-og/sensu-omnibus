source 'https://rubygems.org'

gem 'rake'

# Install omnibus
gem 'omnibus', :git => 'https://github.com/sensu/omnibus.git', :branch => 'sensu'
gem 'ffi-yajl', '2.3.0'
gem 'artifactory', '2.5.1'
gem 'license_scout', '0.1.3'
gem 'mixlib-cli', '1.7.0'
gem 'mixlib-authentication', '2.1.1'
gem 'rubyzip', '1.3.0'

# This development group is installed by default when you run `bundle install`,
# but if you are using Omnibus in a CI-based infrastructure, you do not need
# the Test Kitchen-based build lab. You can skip these unnecessary dependencies
# by running `bundle install --without development` to speed up build times.
group :development do
  # Use Berkshelf for resolving cookbook dependencies
  gem 'berkshelf', '~> 5.6'

  # Use Test Kitchen for converging the build environment
  gem 'test-kitchen',            '~> 1.4'
  gem 'winrm'
  gem 'winrm-fs'
  gem 'winrm-elevated'
end

group :vagrant do
  gem 'kitchen-vagrant',         '~> 0.18'
end

group :ec2 do
  gem 'kitchen-ec2',             '~> 2.0'
end
